module Raisin
	module ExternalServices
		class Pinboard
			attr_accessor :config

			@@utilities = Raisin::ExternalServices::Utilities.new

			# Currently imports checkins.
			def import
				keywords = ["kind:bookmark", "src:pinboard"].map do |keyword|
					Keyword.find_or_create_by_name(keyword)
				end

				last_import = LastImport.first({
						:conditions => { :service_name => "Pinboard" }})
				last_updated = last_import ? last_import.timestamp : nil

				entries = []
				import_error = false

				puts "  * getting items"
				# xxx need to handle error situations -- HTTP errors, empty responses,
				# authentication failure, etc.
#				data = api_call({ :method => "export/" })
data = open("bookmarks.xml").read

# http://stackoverflow.com/questions/4477369/
doc = Nokogiri::HTML(data)
puts doc.xpath("//dt").count
# doc.xpath("//dt/a | //dt[a]/following-sibling::*[1][self::dd]").each do |node|
# 	title = node.text
# 	url = node["href"]
# 	tags = node["tags"].blank? ? "" : node["tags"].split(",").join(", ")
# 	created_at = Time.at(node["add_date"].to_i)
# 
# 
# 	puts " * " * 10
# 	puts title
# 	puts url
# 	puts tags
# 	puts created_at
# end

#					if data && data["activity"] && !data["activity"].empty?
#						items = data["activity"]
#
#						items.each do |item|
#							entry = Entry.first({ :conditions => {
#									:bookmark_url => "http://gowalla.com#{item["url"]}" }})
#
#							# Only process/log previously-unseen itemss
#							unless entry
#								print "."
#								entry = generate_entry(item)
#								entry.keywords = keywords
#								entries << entry
#							end
#
#							# Stop pulling items when we hit an entry that's before our
#							# most recent import.
#							#
#							# xxx possible problem if there's a item while the import is
#							# running (/jordan)
#							if last_updated && entry.created_at < last_updated
#								get_next_page = false
#								break
#							end
#						end
#				puts
#
#				puts "  * found #{entries.length} new entries"
#				# We call the API newest-to-oldest, but it makes more sense for us to
#				# write to the database oldest-to-newest.
#				entries.reverse_each { |entry| entry.save }
#
#				unless import_error
#					if last_import
#						last_import.update_attributes({ :timestamp => Time.now })
#					else
#						LastImport.create({ :service_name => "Gowalla",
#								:timestamp => Time.now })
#					end
#				end
			end

			private
			# Call the Pinboard API.
			#
			# Options:
			#     `:method` -- required, string
			#         (e.g. `"/users/me"`)
			#    `:params` -- optional, hash
			#         (e.g. `{ "max-results" => 25 }`)
			def api_call(options = {})
				headers = {
					:http_basic_authentication => [@config["username"],
							@config["password"]]
				}

				@@utilities.api_call({
						:path => "http://pinboard.in/#{options[:method]}",
						:params => options[:params],
						:headers => headers,
				})
			end

			def generate_entry(item)
				entry = @@utilities.generate_entry({
						:title => item["spot"]["name"],
						:body => item["message"],
						:created_at => item["created_at"],
						:updated_at => item["created_at"],
						:bookmark_url => "http://gowalla.com#{item["url"]}"
				})

				entry
			end
		end
	end
end
