$ = jQuery

Handlebars?.registerHelper "entry_classes", (items, fn) ->
	["hentry", Raisin.helper.keywords_as_classes(items)].join " "

Handlebars?.registerHelper "formatted_title", (item, fn) ->
	# Run through `keywords` until one starts with `"kind:"`.
	for keyword in item.keywords
		if keyword.name.match /kind:/
			switch keyword.name.replace /kind:/, ""
				# TODO I18n
				when "checkin"
					title = "<span class='verb' title='checkin'>checked in at</span>
						<a href='#{item.bookmark_url}' class='bookmark'>#{item.title}</a>"
				when "favorite"
					title = "<span class='verb' title='favorite'>Added
						<q><a href='#{item.bookmark_url}' class='bookmark'>#{item.title}</a></q>
						to favorites</span>
						on #{Raisin.helper.pretty_keyword source}"
				when "status"
					title = "<span class='verb' title='post'>posted</span>
						<q>#{item.title}</q>
						to #{Raisin.helper.pretty_keyword source}"
				else title = item.title

		break if title

	title or= item.title

	new Handlebars.SafeString title

Handlebars?.registerHelper "human_date", (item, fn) ->
	new Date(item).toLocaleDateString()

Handlebars?.registerHelper "entry_link", (item, fn) ->
	# TODO Hack.
	"/entries/#{item.id}"
