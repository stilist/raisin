module Raisin
	module ExternalServices
		class Gowalla
			def initialize
				@@utilities = Raisin::ExternalServices::Utilities.new

				# TODO Remove fallbacks.
				@@config = {
					:username => ENV["GOWALLA_USERNAME"],
					:password => ENV["GOWALLA_PASSWORD"],
					:api_key => ENV["GOWALLA_API_KEY"]
				}

				if @@config[:username] && @@config[:password] && @@config[:api_key]
					@@entry_source = EntrySource.where(:system_name => "gowalla").first

					@@keywords = [@@entry_source.keyword]
					@@keywords << Keyword.find_by_name("kind:checkin")
				else
					puts "Please set the appropriate Gowalla environmental variables."
				end
			end

			# Currently imports checkins.
			def import
				puts "  * getting user info"

				user_info = api_call :method => "users/#{@@config[:username]}"

				last_import = @@entry_source.last_import

				current_page = 1
				get_next_page = true

				puts "  * getting checkins"
				while get_next_page
					entries = []

					# Gowalla API has a hard limit of 25 items per page
					data = api_call :method => user_info["activity_url"],
							:params => { :per_page => 25, :page => current_page }

					if data && data["activity"] && !data["activity"].empty?
						items = data["activity"]

						items.each do |item|
							entry = Entry.where(:bookmark_url => "http://gowalla.com#{item["url"]}").first

							# Only save previously-unseen items.
							unless entry
								print "."
								entry = generate_entry item
								entry.keywords = @@keywords

								# Stop pulling items when if the entry's timestamp is before
								# `last_import`.
								if false #last_import.timestamp && entry.created_at < last_import.timestamp
									get_next_page = false
									break
								else
									entries << entry
								end
							end
						end

						entries.each { |entry| entry.save }
						puts "  * #{entries.length} new entries"

						last_import.update_attributes :timestamp => Time.now

						current_page += 1

						# Limited to 5 requests/second with API key or 1/second without.
						# Enforce maximum of 1/second.
						sleep 1
					else
						get_next_page = false
					end
				end
				puts
			end

			private

			# Call the Gowalla API.
			#
			# Options:
			#     `:method` -- required, string
			#         (e.g. `"/users/me"`)
			#    `:params` -- optional, hash
			#         (e.g. `{ "max-results" => 25 }`)
			def api_call options = {}
				headers = {
					"X-Gowalla-API-Key" => @@config[:api_key],
					"Accept" => "application/json",
					"Content-Type" => "application/json",
					:http_basic_authentication => [@@config[:username],
							@@config[:password]]
				}

				@@utilities.api_call({
					:path => "http://api.gowalla.com/#{options[:method]}",
					:params => options[:params],
					:headers => headers
				})
			end

			def generate_location url
				data = api_call :method => url

				location = Location.find_or_initialize_by_gowalla_id({
					:lat => data["lat"],
					:lng => data["lng"],
					:foursquare_id => data["foursquare_id"],
					:gowalla_id => data["id"].to_s,
					:yelp_id => data["yelp_url"]
				})

				if location.new_record?
					if data["street_address"]
						location.update_attributes :address => "#{data["street_address"]}, #{data["locality"]}, #{data["region"]}"
					end
				end

				location
			end

			def generate_entry item
				entry = @@utilities.generate_entry({
					:title => item["spot"]["name"],
					:body => item["message"],
					:created_at => item["created_at"],
					:updated_at => item["created_at"],
					:bookmark_url => "http://gowalla.com#{item["url"]}",
					:entry_source_id => @@entry_source.id
				})

				location = generate_location item["spot"]["url"]
				entry.locations = [location].flatten

				entry
			end
		end
	end
end
