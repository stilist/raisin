class Entry < ActiveRecord::Base
	has_and_belongs_to_many :keywords
	has_and_belongs_to_many :locations
	has_one :entry_source

	validates :title, :presence => true

	default_scope order("entries.created_at DESC").joins([:keywords, :locations])

	def has_locations?
		!self.locations.empty?
	end
end
