module KeywordsHelper
	def keywords_as_classes entry
		# example output: `"kind_favorite src_youtube"`
		entry.keywords.sort.map { |keyword| sanitized_keyword keyword }.join(" ")
	end

	def pretty_keyword keyword
		keyword.name.sub(/[a-z]+:/, "").humanize
	end

	def sanitized_keyword keyword
		keyword.name.gsub(%r{[^a-zA-Z0-9]}, "_")
	end
end
