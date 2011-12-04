class AddKeywordIdToEntrySource < ActiveRecord::Migration
	def change
		add_column :entry_sources, :keyword_id, :integer
	end
end
