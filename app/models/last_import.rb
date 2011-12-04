class LastImport < ActiveRecord::Base
	belongs_to :entry_source

	validates :entry_source_id, :numericality => true
end
