class CreateEntrySources < ActiveRecord::Migration
	def up
		create_table :entry_sources do |t|
			t.string :system_name, :null => false
			t.string :display_name, :null => false
			t.string :homepage, :null => false

			t.timestamps
		end

		add_column :entries, :entry_source_id, :integer
	end

	def down
		drop_table :entry_sources
		remove_column :entries, :entry_source_id
	end
end
