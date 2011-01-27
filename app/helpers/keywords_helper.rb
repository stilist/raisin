module KeywordsHelper
	def pretty_keyword(keyword)
		keyword.name.sub(/[a-z]+:/, "").humanize
	end

	def sanitized_keyword(keyword)
		keyword.name.gsub(%r{[^a-zA-Z0-9]}, "_")
	end
end
