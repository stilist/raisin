class EntrySource < ActiveRecord::Base
	has_many :entries
	belongs_to :keyword
	has_one :last_import

	validates :system_name, :presence => true
	validates :display_name, :presence => true
end
