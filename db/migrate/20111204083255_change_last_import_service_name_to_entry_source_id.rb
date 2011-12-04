class ChangeLastImportServiceNameToEntrySourceId < ActiveRecord::Migration
	def up
		add_column :last_imports, :entry_source_id, :integer
		remove_column :last_imports, :service_name
	end

	def down
		add_column :last_imports, :service_name, :string
		remove_column :last_imports, :entry_source_id
	end
end
