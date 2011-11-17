# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
	def generate_markers items
		markers = []

		items.each do |item|
			item.locations.each do |location|
				markers << { "lat" => location[:lat], "lng" => location[:lng] }
			end
		end

		markers.uniq
	end
end
