class AddGowallaIdToLocations < ActiveRecord::Migration
	def change
		change_table :locations do |t|
			t.string :facebook_id
			t.string :foursquare_id
			t.string :google_id
			t.string :gowalla_id
			t.string :yelp_id
		end
	end
end
