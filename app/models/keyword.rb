class Keyword < ActiveRecord::Base
	has_and_belongs_to_many :entries

	validates_presence_of :name
end
