#= require jquery
#= require jquery_ujs
# vendor
#= require jquery.offline
#= require es5-shim.min
#= require handlebars.1.0.0.beta.3
# Raisin
#= require raisin.helper
#= require entry_helper
#= require keyword_helper

$ = jQuery

window.generate_map = (options) ->
	settings = jQuery.extend
		markers: []
		map_id: ""
	, options

	$map = $("##{settings.map_id}").empty()

	if google? and not settings.markers.length is 0
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

		$(window).bind "resize.map", -> map.fitBounds bounds
	else
		$map.delay(500).slideUp 500
