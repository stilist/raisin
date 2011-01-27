# http://gdata.youtube.com/feeds/base/users/stilist/favorites?client=ytapi-youtube-user&v=2&max-results=50&start-index=450

module Raisin
	module ExternalServices
		class Youtube
			attr_accessor :config

			@@utilities = Raisin::ExternalServices::Utilities.new

			# Currently imports favorites. TODO: uploads, comments.
			def import
				keywords = ["kind:favorite", "src:youtube"].map do |keyword|
					Keyword.find_or_create_by_name(keyword)
				end

				last_updated = @@utilities.last_updated({ :service_name => "YouTube" })

				entries = []
				current_offset = 0
				get_next_page = true
				per_page = 50
				import_error = false

				puts "  * getting favorites"
				# xxx need to handle error situations -- HTTP errors, empty responses,
				# authentication failure, etc.
				until !get_next_page
					params = { "max-results" => per_page }
					if current_offset > 0
						params.merge!({ "start-index" => current_offset })
					end
					favorites = api_call({ :method => "favorites", :params => params })

					if favorites && favorites["feed"] && favorites["feed"]["entry"] && !favorites["feed"]["entry"].empty?
						favorites["feed"]["entry"].each do |item|
							bookmark_url = item["link"].first["href"].sub("&feature=youtube_gdata", "")

							entry = Entry.first({ :conditions => {
									:bookmark_url => bookmark_url }})

							# Only process/log previously-unseen items
							unless entry
								print "."
								entry = generate_entry(item)
								entry.keywords = keywords
								entries << entry
							end

							# Stop pulling items when we hit an entry that's before our
							# most recent import.
							#
							# xxx possible problem if there's a item while the import is
							# running (/jordan)
						end

						current_offset += per_page

						sleep 1
					else
						import_error = true
						get_next_page = false
					end
				end
				puts

				puts "  * found #{entries.length} new items"
				# Insert oldest-to-newest.
				entries.reverse_each { |entry| entry.save }

				unless import_error
					if last_import
						last_import.update_attributes({ :timestamp => Time.now })
					else
						LastImport.create({ :service_name => "YouTube",
								:timestamp => Time.now })
					end
				end
			end

			private
			# Call the YouTube API.
			#
			# Options:
			#    `:method` -- required; API method
			#       (e.g. `"favorites"`)
			#    `:params` -- optional; hash of arguments for query string
			#       (e.g. `{ "max-results" => 25 }`)
			def api_call(options = {})
				params = { :client => "ytapi-youtube-user", :alt => "json" }
				params.merge!(options[:params]) if options[:params]

				@@utilities.api_call({
						:path => "http://gdata.youtube.com/feeds/base/users/#{@config["username"]}/#{options[:method]}",
						:params => params
				})
			end

			def generate_entry(item)
				@@utilities.generate_entry({
						:title => item["title"]["$t"],
						:created_at => item["updated"]["$t"],
						:updated_at => item["updated"]["$t"],
						:bookmark_url => item["link"].first["href"].
								sub("&feature=youtube_gdata", "")
				})
			end
		end
	end
end
