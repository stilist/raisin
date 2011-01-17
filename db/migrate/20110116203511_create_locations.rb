class CreateLocations < ActiveRecord::Migration
	def self.up
		create_table :locations do |t|
			t.string :address
			t.decimal :lat, { :precision => 15, :scale => 10 }
			t.decimal :lng, { :precision => 15, :scale => 10 }
			t.text :geoloc

			t.timestamps
		end

		create_table :entries_locations, :id => false do |t|
			t.references :entry
			t.references :location

			t.timestamps
		end

		add_index :locations, [:lat, :lng]
	end

	def self.down
		drop_table :locations
		drop_table :entries_locations
	end
end
