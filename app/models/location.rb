class Location < ActiveRecord::Base
	has_and_belongs_to_many :entries

	# GeoKit
	acts_as_mappable
	serialize :geoloc

	validates :lat, :allow_nil => true, :numericality => true
	validates :lng, :allow_nil => true, :numericality => true
end
