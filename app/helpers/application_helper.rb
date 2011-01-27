# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def generate_map(locations, map_id)
		boundary_points = []
		markers = []

		if locations.is_a?(Array) && !locations.empty?
			markers = locations.map do |location|
				{ :lat => location[:lat], :lng => location[:lng] }
			end

			unless markers.empty?
				sort_lat = Proc.new { |location| location[:lat] }
				sort_lng = Proc.new { |location| location[:lng] }

				sorted_latitudes = markers.collect(&sort_lat).compact.sort
				sorted_longitudes = markers.collect(&sort_lng).compact.sort
			end
		end

		"<div class='map' id=#{map_id}></div>
		<script>
			marker = #{markers[0].to_json};
			generate_map({
				marker: marker,
				map_id: '#{map_id}'
			});
		</script>"
	end
end
