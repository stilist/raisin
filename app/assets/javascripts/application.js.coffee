#= require "handlebars.1.0.0.beta.3"
#= require "jquery.offline"
#= require "jquery.sparkline.min"

$ = jQuery

$keyword_icon_box_proto = $("<div class='keyword_icons'></div>")

$(document).ready ->
	$(".hentry").each ->
		$keywords = $(this).find(".keywords li")

		if $keywords.length > 0
			$keyword_icon_box = $keyword_icon_box_proto.clone()

			$(this).append $keyword_icon_box

			$keywords.each ->
				keyword_name = $(this).attr("class").split("tag ")[1]
				$keyword_icon_box.append "<span class='keyword #{keyword_name}'></span>"

window.generate_sparklines = (data) ->
	$activity_types = $("#activity_types")

	for activity in activities
		counts = activity.counts
		pretty_name = activity.name.split(":")[1]

		$activity = $("<li class='#{pretty_name}'>" +
			"  <a href='/keywords/#{activity.id}'>#{activity.name}</a>" +
			"  <span class='sparkline'></span>" +
			"</li>")
		$activity_types.append $activity

		options =
			fillColor: false
			lineColor: activity.color
			minSpotColor: false
			maxSpotColor: false
			spotColor: "#fff"

		$activity.children(".sparkline").sparkline counts, options

window.generate_map = (options) ->
	settings = jQuery.extend
		markers: []
		map_id: ""
	, options

	if google? && false is true
		myOptions =
			disableDefaultUI: true
			center: new google.maps.LatLng 0, 0
			mapTypeId: google.maps.MapTypeId.ROADMAP
			zoom: 0

		map = new google.maps.Map document.getElementById(settings.map_id),
				myOptions

		bounds = new google.maps.LatLngBounds()

		for marker in settings.markers
			latlong = new google.maps.LatLng marker.lat, marker.lng
			bounds.extend latlong

			new google.maps.Marker
				position: latlong
				map: map

		map.fitBounds bounds
