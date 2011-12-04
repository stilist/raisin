$ = jQuery

$(document).ready ->
	$entry_template = $("#entry_template")
	$feed = $(".hfeed")

	if $entry_template.length isnt 0
		SOURCE = $entry_template.html()
		TEMPLATE = Handlebars.compile SOURCE

		render_entries = (url) ->
			# TODO Cache invalidation, pagination update, history, etc.
			$.retrieveJSON url, (response, status, data) ->
				locations = []

				$(".hentry").remove()

				for item in response
					$feed.prepend $(TEMPLATE item)
					locations.push item.locations

				# generate_map
				# 	markers: $.unique locations
				# 	map_id: "map"

		# TODO Disabled because it's not fully functional yet.
		# $("a").bind "click.entries", (e) ->
		# 	if $(this).prop("rel") in ["next", "prev"]
		# 		e.preventDefault()

		# 		render_entries $(this).prop "href"
