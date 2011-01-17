class Location < ActiveRecord::Base
	has_and_belongs_to_many :entries

	# GeoKit
	acts_as_mappable
	serialize :geoloc
	before_validation :geocode_address

	validates_numericality_of :lat, { :allow_nil => true }
	validates_numericality_of :lng, { :allow_nil => true }

	private
	def geocode_address
		if !self.address.blank? && self.lat.nil? && self.lng.nil?
			geo = Geokit::Geocoders::MultiGeocoder.geocode(address)
			if geo.success
				self.lat, self.lng, self.geoloc = geo.lat, geo.lng, geo
			else
				errors.add(:address, "Could not find address")
			end
		else
			errors.add(:address, "Unusable location (no address or coordinates)")
		end
	end
end
