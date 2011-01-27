module Raisin
	module ExternalServices
		class Twitter
			require "twitter_oauth"

			attr_accessor :client
			attr_accessor :config
			attr_accessor :config_file
			attr_accessor :user_name

			@@utilities = Raisin::ExternalServices::Utilities.new

			# Currently imports tweets. TODO: favorites (in and out),
			# retweets (in and out), @replies (in)
			def import
				@client = oauth_client

				post_keywords = ["kind:status", "src:twitter"].map do |keyword|
					Keyword.find_or_create_by_name(keyword)
				end

				last_import = LastImport.first({
						:conditions => { :service_name => "Twitter" }})
				last_updated = last_import ? last_import.timestamp : nil

				# posts

				entries = []
				current_page = 1
				get_next_page = true
				per_page = 200

				puts "  * getting statuses"
				# xxx need to handle error situations -- HTTP errors, empty responses,
				# authentication failure, etc.
				until !get_next_page
					items = api_call(:user_timeline, { :count => per_page,
							:page => current_page })
					# stop looking if the API doesn't like us
					if items.is_a?(Array)
						unless items.empty?
							items.each do |item|
								entry = Entry.first({ :conditions => {
										:bookmark_url => "https://twitter.com/#{item["user"]["screen_name"]}/status/#{item["id"]}" }})

								# Only process/log previously-unseen statuses
								unless entry
									print "."
									entry = generate_entry(item)
									entry.keywords = post_keywords
									entries << entry
								end

								# Stop pulling items when we hit an entry that's before our
								# most recent import.
								#
								# xxx possible problem if there's a status update while the
								# import is running (/jordan)
								if last_updated && entry.created_at < last_updated
									get_next_page = false
								end
							end

							current_page += 1

							sleep 3
						else
							get_next_page = false
						end
					else
						get_next_page = false
					end
				end
				puts

				# favorites

				favorite_keywords = ["kind:favorite", "src:twitter"].map do |keyword|
					Keyword.find_or_create_by_name(keyword)
				end

				current_page = 1
				get_next_page = true

				puts "  * getting favorites"
				# xxx need to handle error situations -- HTTP errors, empty responses,
				# authentication failure, etc.
				until current_page == 4
					items = api_call(:favorites, { :page => current_page })

					# stop looking if the API doesn't like us
					if items.is_a?(Array)
						unless items.empty?
							items.each do |item|
								entry = Entry.first({ :conditions => {
										:bookmark_url => "https://twitter.com/#{item["user"]["screen_name"]}/status/#{item["id"]}" }})

								# Only process/log previously-unseen statuses
								unless entry
									print "."
									entry = generate_entry(item)
									entry.keywords = favorite_keywords
									entries << entry
								end
							end

							current_page += 1

							sleep 3
						else
							get_next_page = false
						end
					else
						get_next_page = false
					end
				end
				puts

				puts "  * found #{entries.length} new items"
				# We call the API newest-to-oldest, but it makes more sense for us to
				# write to the database oldest-to-newest.
				entries.reverse_each { |entry| entry.save }

				unless entries.empty?
					if last_import
						last_import.update_attributes({ :timestamp => Time.now })
					else
						LastImport.create({ :service_name => "Twitter",
								:timestamp => Time.now })
					end
				end
			end

			private
			# e.g. api_call(:user_timeline, { :page => 2 })
			def api_call(method, options)
				begin
					# weird decision in twitter_oauth
					if method == :favorites && options[:page]
						@client.send(method, options[:page])
					else
						@client.send(method, options)
					end
				rescue OpenURI::HTTPError => the_error
					puts "\n\nERROR #{the_error.message}\n\n"
					:error
				end
			end

			def generate_entry(item)
				entry = @@utilities.generate_entry({
						:title => item["text"],
						:created_at => DateTime.parse(item["created_at"]),
						:updated_at => DateTime.parse(item["created_at"]),
						:bookmark_url => "https://twitter.com/#{item["user"]["screen_name"]}/status/#{item["id"]}"
				})

				if item["geo"]
					location = Location.find_or_initialize_by_lat_and_lng(
							item["geo"]["coordinates"])
					entry.locations = [location]
				end

				entry
			end

			def oauth_authorize
				consumer = OAuth::Consumer.new(@config["consumer_key"],
						@config["consumer_secret"],
						{ :site => "http://twitter.com",
							:request_token_path => "/oauth/request_token",
							:access_token_path => "/oauth/access_token",
							:authorize_path => "/oauth/authorize"
						}
				)
				request_token = consumer.get_request_token

				puts "Please open the following address in your browser to authorize this application:"
				puts
				puts "#{request_token.authorize_url}\n"
				puts
				puts "Enter your pin and hit return when you have completed authorization."
				print "> "
				pin = STDIN.readline.chomp

				access_token = request_token.get_access_token({
						:oauth_verifier => pin })

				@config.merge!({ "request_token" => access_token.token,
						"request_secret" => access_token.secret })

				# Update the config file with our completed authorization.
				services_config = YAML.load_file(@config_file)
				services_config["twitter"] = @config
				File.open(@config_file, "w") do |out|
					YAML::dump(services_config, out)
				end
			end

			def oauth_client
				if @config["consumer_key"].nil? || @config["consumer_secret"].nil?
					abort "\n\nPlease register this application with Twitter and edit config/external_services.yml\n\n"
				end

				# Not yet authorized
				if @config["request_token"].nil? || @config["request_secret"].nil?
					oauth_authorize
				end

				TwitterOAuth::Client.new({
						:consumer_key => @config["consumer_key"],
						:consumer_secret => @config["consumer_secret"],
						:token => @config["request_token"],
						:secret => @config["request_secret"]
				})
			end
		end
	end
end
