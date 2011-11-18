$ = jQuery

Handlebars?.register_helper "sanitized_keyword", (item, fn) ->
	Raisin.helper.sanitized_keyword item

Handlebars?.register_helper "keyword_link", (item, fn) ->
	# TODO Hack.
	"/keywords/#{item.id}"
