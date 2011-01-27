module EntriesHelper
	def keywords_as_classes(entry)
		# example output: `"kind_favorite src_youtube"`
		entry.keywords.sort do |a,b|
			a.name <=> b.name
		end.map do |keyword|
			sanitized_keyword(keyword)
		end.join(" ")
	end

	def formatted_title(entry)
		keywords = entry.keywords
		kind = keywords.select { |k| k.name =~ /\Akind:/ }.first
		source = keywords.select { |k| k.name =~ /\Asrc:/ }.first

		case kind.name.sub("kind:", "")
		when "checkin" then
			"<span class='verb' title='checkin'>checked in at</span>
			 #{link_to(entry.title, entry.bookmark_url, { :class => "bookmark" })}
			 with #{pretty_keyword(source)}#{":" unless entry.body.blank? }"
		when "favorite" then
			"<span class='verb' title='favorite'>Added
			 <q>#{link_to(entry.title, entry.bookmark_url, { :class => "bookmark" })}</q>
			 to favorites</span>
			 on #{pretty_keyword(source)}#{":" unless entry.body.blank? }"
		when "status" then
			"<span class='verb' title='post'>posted</span>
			 <q>#{auto_link(entry.title)}</q>
			 to #{pretty_keyword(source)}#{":" unless entry.body.blank? }"
		else
			entry.title
		end
	end

	def entry_classes(entry)
		classes = ["hentry", keywords_as_classes(entry)]
		classes << "has_locations" if entry.has_locations?

		classes.join(" ")
	end
end
