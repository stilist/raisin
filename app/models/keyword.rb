class Keyword < ActiveRecord::Base
	require "digest/md5"

	has_and_belongs_to_many :entries

	validates_presence_of :name

	def color
		"#" << Digest::MD5.hexdigest(self.name)[0..5]
	end
end
