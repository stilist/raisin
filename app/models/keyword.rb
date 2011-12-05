class Keyword < ActiveRecord::Base
	require "digest/md5"

	has_and_belongs_to_many :entries
	has_one :entry_source

	validates :name, :presence => true
end
