puts "Seeding..."

puts "  * keywords"
keywords = %w(kind:bookmark kind:checkin kind:favorite kind:image kind:like kind:listen kind:status kind:text src:flickr src:gowalla src:twitter src:youtube)
keywords.each do |keyword_name|
	keyword = { :name => keyword_name }
	Keyword.find_or_create_by_name(keyword)
end
