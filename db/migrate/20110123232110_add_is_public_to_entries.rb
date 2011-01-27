class AddIsPublicToEntries < ActiveRecord::Migration
	def self.up
		add_column :entries, :is_public, :boolean, :default => true
	end

	def self.down
		remove_column :entries, :is_public
	end
end
