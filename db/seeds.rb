puts "Adding seed data..."

puts " * keywords"
%w(kind:bookmark kind:checkin kind:favorite kind:image kind:like kind:listen kind:status).each do |name|
	keyword = { :name => name }

	Keyword.find_or_create_by_name keyword
end

puts " * entry sources"
[
	{ :system_name => "flickr", :display_name => "Flickr",
			:homepage => "http://flickr.com" },
	{ :system_name => "gowalla", :display_name => "Gowalla",
			:homepage => "http://gowalla.com" },
	{ :system_name => "twitter", :display_name => "Twitter",
			:homepage => "http://twitter.com" },
	{ :system_name => "youtube", :display_name => "YouTube",
			:homepage => "http://youtube.com" }
].each do |source|
	keyword = Keyword.find_or_create_by_name "src:#{source[:system_name]}"

	src = EntrySource.find_or_create_by_system_name source
	src.update_attributes :keyword => keyword if src

	unless src.last_import
		src.build_last_import
		src.save
	end
end
