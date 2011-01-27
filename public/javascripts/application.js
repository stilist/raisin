jQuery(document).ready(function ($) {
	var $entries = $(".hentry"),
			$keywords,
			$keyword_icons,
			$keyword_icon_box,
			$keyword_icon_box_proto = $("<div class='keyword_icons'></div>"),
			keyword_name;

	$entries.each(function () {
		$keywords = $(this).find(".keywords li");

		if (0 < $keywords.size()) {
			$keyword_icon_box = $keyword_icon_box_proto.clone();

			$(this).append($keyword_icon_box);

			$keywords.each(function () {
				keyword_name = $(this).attr("class").split("tag ")[1];
				$keyword_icon_box.append("<span class='keyword " + keyword_name +
						"'></span>");
			});
		}
	});
});

function generate_sparklines(options) {
	var settings = jQuery.extend({
				activity: [],
				longest_streak: 0
			}, options),

			activity_count = settings.activity.length,
			$activity_types = jQuery("#activity_types"),

			source = {},
			activity_data = [],
			activity_name = "",
			streak_shortfall = 0,
			$activity;

	for (var i = 0; i < activity_count; ++i) {
		activity = settings.activity[i];

		activity_name = activity.name.split(":")[1];

		// make sure all sources are working with the same amount of data
		streak_shortfall = settings.longest_streak - activity.counts.length;
		if (0 < streak_shortfall) {
			activity_data = [];
			for (var j = 0; j < streak_shortfall; ++j) {
				activity_data.push(0);
			}
			jQuery.merge(activity_data, activity.counts);
		} else {
			activity_data = activity.counts;
		}

		$activity = jQuery("<li class='" + activity_name + "'>" +
			"  <a href='/keywords/" + activity.id + "'>" + activity_name + "</a>" +
			"  <span class='sparkline'></span>" +
			"</li>");
		$activity_types.append($activity);

		$activity.children(".sparkline").sparkline(activity_data,
				{
					fillColor: false,
					lineColor: activity.color,
					minSpotColor: false,
					maxSpotColor: false,
					spotColor: "#fff"
				}
		);
	}
}

function generate_map(options) {
	var settings = jQuery.extend({
				marker: [],
				map_id: ""
			}, options),
			geocoder,
			marker,
			myLatlng,
			myMarker,
			myOptions,
			map;

	if (undefined !== google) {
		myLatlng = new google.maps.LatLng(settings.marker.lat,settings.marker.lng);

		myOptions = {
			zoom: 13,
			center: myLatlng,
			disableDefaultUI: true,
			mapTypeId: google.maps.MapTypeId.ROADMAP
		}

		map = new google.maps.Map(document.getElementById(settings.map_id), myOptions);

		marker = new google.maps.Marker({
			position: myLatlng,
			map: map
		});
	}
}
