class Entry < ActiveRecord::Base
	has_and_belongs_to_many :keywords
	has_and_belongs_to_many :locations

	validates_presence_of :title

	default_scope order("entries.created_at DESC").joins([:keywords, :locations])

	def has_locations?
		!self.locations.empty?
	end
end
