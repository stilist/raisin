class Keyword < ActiveRecord::Base
	require "digest/md5"

	has_and_belongs_to_many :entries
	has_one :entry_source

	validates :name, :presence => true

	def color
		"#" << Digest::MD5.hexdigest(self.name)[0..5]
	end
end
