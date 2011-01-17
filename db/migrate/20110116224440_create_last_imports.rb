class CreateLastImports < ActiveRecord::Migration
	def self.up
		create_table :last_imports do |t|
			t.string :service_name, { :null => false }
			t.datetime :timestamp
		end
	end

	def self.down
		drop_table :last_imports
	end
end
