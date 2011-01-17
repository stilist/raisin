class Entry < ActiveRecord::Base
	has_and_belongs_to_many :keywords
	has_and_belongs_to_many :locations

	validates_presence_of :title
end
