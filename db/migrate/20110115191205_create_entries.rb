class CreateEntries < ActiveRecord::Migration
	def self.up
		create_table :entries do |t|
			t.string :title, { :null => false }
			t.text :body
			t.string :bookmark_url

			t.timestamps
		end
	end

	def self.down
		drop_table :entries
	end
end
