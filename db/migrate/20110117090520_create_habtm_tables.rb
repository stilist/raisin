class CreateHabtmTables < ActiveRecord::Migration
	def self.up
		create_table :entries_keywords, :id => false do |t|
			t.references :entry
			t.references :keyword

			t.timestamps
		end

	end

	def self.down
	end
end
