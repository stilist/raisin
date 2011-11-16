module Raisin
	module ExternalServices
		class Gowalla
			def initialize
				@@utilities = Raisin::ExternalServices::Utilities.new

				begin
					config_path = File.join Rails.root, "config", "external_services.yml"
					config = YAML.load_file config_path
					@@config = SERVICES_CONFIG["gowalla"]
				rescue Exception => e
					abort "\n\nERROR: #{e}\n\n"
				end
			end

			# Currently imports checkins.
			def import
				puts "  * getting user info"

				user_info = api_call :method => "users/#{@@config["username"]}"

				keywords = %w(kind:checkin src:gowalla).map do |keyword|
					Keyword.find_or_create_by_name keyword
				end

				last_import = LastImport.where(:service_name => "Gowalla").first
				last_updated = last_import ? last_import.timestamp : nil

				entries = []
				current_page = 1
				get_next_page = true
				import_error = false

				puts "  * getting checkins"
				# xxx need to handle error situations -- HTTP errors, empty responses,
				# authentication failure, etc.
				until !get_next_page
					# Gowalla API has a hard limit of 25 items per page
					data = api_call :method => user_info["activity_url"],
							:params => { :per_page => 25, :page => current_page }

					if data && data["activity"] && !data["activity"].empty?
						items = data["activity"]

						items.each do |item|
							entry = Entry.
									where(:bookmark_url => "http://gowalla.com#{item["url"]}").
									first

							# Only process/log previously-unseen itemss
							unless entry
								print "."
								entry = generate_entry item
								entry.keywords = keywords
								entries << entry
							end

							# Stop pulling items when we hit an entry that's before our
							# most recent import.
							#
							# xxx possible problem if there's a item while the import is
							# running (/jordan)
							if last_updated && entry.created_at < last_updated
								get_next_page = false
								break
							end
						end
						current_page += 1

						# Limited to 5 requests/second with API key or 1/second without.
						# Automatically limit ourselves to 1/second.
						sleep 1
					else
						import_error = true
						get_next_page = false
					end
				end
				puts

				puts "  * found #{entries.length} new checkins"
				# We call the API newest-to-oldest, but it makes more sense for us to
				# write to the database oldest-to-newest.
				entries.reverse_each { |entry| entry.save }

				unless import_error
					if last_import
						last_import.update_attributes :timestamp => Time.now
					else
						LastImport.create :service_name => "Gowalla",
								:timestamp => Time.now
					end
				end
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
					"X-Gowalla-API-Key" => @@config["api_key"],
					"Accept" => "application/json",
					"Content-Type" => "application/json",
					:http_basic_authentication => [@@config["username"],
							@@config["password"]]
				}

				@@utilities.api_call({
					:path => "http://api.gowalla.com/#{options[:method]}",
					:params => options[:params],
					:headers => headers
				})
			end

			def generate_entry item
				entry = @@utilities.generate_entry({
					:title => item["spot"]["name"],
					:body => item["message"],
					:created_at => item["created_at"],
					:updated_at => item["created_at"],
					:bookmark_url => "http://gowalla.com#{item["url"]}"
				})

				location = Location.find_or_initialize_by_lat_and_lng({
					:lat => item["spot"]["lat"],
					:lng => item["spot"]["lng"],
					:name => item["spot"]["name"]
				})

				if location.new_record?
					location_data = api_call :method => item["spot"]["url"]

					if location_data["street_address"]
						location.address = "#{location_data["street_address"]}, #{location_data["locality"]}, #{location_data["region"]}"
					end
				end

				entry.locations = [location].flatten

				entry
			end
		end
	end
end
