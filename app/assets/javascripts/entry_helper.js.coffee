$ = jQuery

Handlebars?.register_helper "entry_classes", (items, fn) ->
	["hentry", Raisin.helper.keywords_as_classes(items)].join " "

Handlebars?.register_helper "formatted_title", (item, fn) ->
	# Run through `keywords` until finding one that starts with `"kind:"`.
	for keyword in item.keywords
		if keyword.match /kind:/
			title = switch keyword.replace /kind:/, ""
				# TODO I18n
				when "checkin"
					"<span class='verb' title='checkin'>checked in at</span>
						<a href='#{entry.bookmark_url}' class='bookmark'>#{entry.title}</a>
					 with #{Raisin.helper.pretty_keyword source}#{":" if entry.body.length > 0 }"
				when "favorite"
					"<span class='verb' title='favorite'>Added
						<q><a href='#{entry.bookmark_url}' class='bookmark'>#{entry.title}</a></q>
						to favorites</span>
						on #{Raisin.helper.pretty_keyword source}#{":" if entry.body.length > 0}"
				when "status"
					"<span class='verb' title='post'>posted</span>
						<q>#{entry.title}</q>
						to #{Raisin.helper.pretty_keyword source}#{":" if entry.body.length > 0}"
				else item.title
		break if title
	title or item.title

Handlebars?.register_helper "iso8601", (item, fn) ->
	item.toISOString()

Handlebars?.register_helper "human_date", (item, fn) ->
	#TODO I18n
	item

Handlebars?.register_helper "entry_link", (item, fn) ->
	# TODO Hack.
	"/entries/#{item.id}"
