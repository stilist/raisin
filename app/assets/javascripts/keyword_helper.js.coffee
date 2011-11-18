$ = jQuery

Handlebars?.registerHelper "sanitized_keyword", (item, fn) ->
	Raisin.helper.sanitized_keyword item

Handlebars?.registerHelper "keyword_link", (item, fn) ->
	# TODO Hack.
	"/keywords/#{item.id}"
