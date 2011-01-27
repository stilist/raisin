class AddIndexesForIds < ActiveRecord::Migration
	def self.up
		add_index :entries, :id
		add_index :entries_keywords, [:entry_id, :keyword_id]
		add_index :keywords, :id
	end

	def self.down
		remove_index :entries, :id
		remove_index :entries_keywords, [:entry_id, :keyword_id]
		remove_index :keywords, :id
	end
end
