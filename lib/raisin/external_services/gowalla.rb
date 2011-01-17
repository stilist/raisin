module Raisin
	module ExternalServices
		class Gowalla
			require "crack/json"
			require "open-uri"

			attr_accessor :options

			def import
				user_info = get_user_info
				checkins_url = user_info["activity_url"]

				keywords = ["kind:checkin", "src:gowalla"].map do |keyword|
					Keyword.find_or_create_by_name(keyword)
				end

				entries = []
				current_page = 1
				get_next_page = true
				per_page = 25

				puts "  * getting checkins"
				until !get_next_page
					# API has a hard limit of 25 checkins per page
					checkins_url << "?per_page=#{per_page}&page=#{current_page}"
					checkins = get_checkins({ :url => checkins_url })

					if checkins["activity"] && !["activity"].empty?
						checkins["activity"].each do |checkin|
							entry = Entry.first({ :conditions => {
									:bookmark_url => "http://gowalla.com#{checkin["url"]}" }})

							# xxx utilize @options["last_updated"]

							# Only process/log previously-unseen checkins
							unless entry
								print "."
								entry = generate_entry(checkin)
								entry.keywords = keywords
								entries << entry
							end
						end
						current_page += 1

						# If the current page has fewer items than `per_page` we can assume
						# it's the last one with data.
						if checkins["activity"].length < per_page
							get_next_page = false
						else
							# Limited to 5 requests/second with API key or 1/second without.
							# Automatically limit ourselves to 1/second.
							sleep 1
						end
					else
						get_next_page = false
					end
				end
				puts

				puts "  * found #{entries.length} new checkins"
				# We call the API newest-to-oldest, but it makes more sense for us to
				# write to the database oldest-to-newest.
				entries.reverse_each { |entry| entry.save }
			end

			private

			def api_call(options)
				begin
					data = open("http://api.gowalla.com/#{options[:url]}", {
							"X-Gowalla-API-Key" => @options["api_key"],
							"Accept" => "application/json",
							"Content-Type" => "application/json",
							"User-Agent" => "Raisin Lifestream",
							:http_basic_authentication => [@options["username"],
									@options["password"]]
					}).read
					return Crack::JSON.parse(data)
				rescue OpenURI::HTTPError => the_error
					puts "\n\nERROR #{the_error.message}\n\n"
				end
			end

			def generate_entry(checkin)
				spot = checkin["spot"]

				entry = Entry.new
				entry.title = "Checked in at #{spot["name"]}"
				entry.created_at = checkin["created_at"]
				entry.bookmark_url = "http://gowalla.com#{checkin["url"]}"
				entry.body = checkin["message"] unless checkin["message"].blank?

				location = Location.find_or_initialize_by_lat_and_lng({
						:lat => spot["lat"], :lng => spot["lng"],
						:name => spot["name"] })
				if location.new_record?
					location_data = get_location({ :url => spot["url"] })
					if location_data["street_address"]
						location.address = "#{location_data["street_address"]}, #{location_data["locality"]}, #{location_data["region"]}"
					end
				end
				entry.locations = [location]

				entry
			end

			def get_checkins(options)
				api_call(options)
			end

			def get_location(options)
				api_call(options)
			end

			def get_user_info
				api_call({ :url => "users/#{options["username"]}" })
			end
		end
	end
end
