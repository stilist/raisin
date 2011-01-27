class Entry < ActiveRecord::Base
	has_and_belongs_to_many :keywords
	has_and_belongs_to_many :locations

	validates_presence_of :title

	def has_locations?
		!self.locations.empty?
	end
end
