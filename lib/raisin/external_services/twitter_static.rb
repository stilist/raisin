module Raisin
	module ExternalServices
		class TwitterStatic
			@@utilities = Raisin::ExternalServices::Utilities.new

			# Currently imports tweets. TODO: favorites (in and out),
			# retweets (in and out), @replies (in)
			def import
				keywords = ["kind:status", "src:twitter"].map do |keyword|
					Keyword.find_or_create_by_name(keyword)
				end

				last_import = LastImport.first({
						:conditions => { :service_name => "Twitter" }})
				last_updated = last_import ? last_import.timestamp : nil

				entries = []
				puts "  * parsing statuses"

				# `ARGV[0]` gives us the name of the rake task that invokes this, so we
				# have to use `ARGV[1]` instead
				data = File.open(ARGV[1], "r").read
				items = Crack::JSON.parse(data)
				unless items.empty?
					items.each do |item|
						entry = Entry.first({ :conditions => {
								:bookmark_url => "https://twitter.com/#{@user_name}/status/#{item["id"]}" }})

						unless entry
							print "."
							entry = generate_entry(item)
							entry.keywords = keywords
							entries << entry
						end
					end
				end
				puts

				puts "  * found #{entries.length} new statuses"
				# We read newest-to-oldest, but it makes more sense to write to the
				# database oldest-to-newest.
				entries.reverse_each { |entry| entry.save }

				if last_import
					last_import.update_attributes({ :timestamp => Time.now })
				else
					LastImport.create({ :service_name => "Twitter",
							:timestamp => Time.now })
				end
			end

			private
			def generate_entry(item)
				entry = @@utilities.generate_entry({
						:title => item["text"],
						:body => item["text"],
						:created_at => DateTime.parse(item["created_at"]),
						:updated_at => DateTime.parse(item["created_at"]),
						:bookmark_url => "https://twitter.com/#{@user_name}/status/#{item["id"]}"
				})

				if item["geo"]
					location = Location.find_or_initialize_by_lat_and_lng(
							item["geo"]["coordinates"])
					entry.locations = [location]
				end

				entry
			end
		end
	end
end
