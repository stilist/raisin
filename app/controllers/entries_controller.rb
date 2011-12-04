class EntriesController < ApplicationController
	layout "default"

	def index
		@entries = Entry.page params[:page]

		respond_to do |format|
			format.html
			format.json do
				render :json => @entries.map { |entry| entry_to_json entry }.to_json
			end
		end
	end

	def show
		@entry = Entry.where(:id => params[:id]).joins([:locations]).first
		if @entry
			@page_title = @entry.title
		else
			redirect_to root_url
		end
	end

	private

	def entry_to_json entry
		data = {
			:id => entry.id,
			:id_str => entry.id.to_s,
			:body => entry.body,
			:bookmark_url => entry.bookmark_url,
			:title => entry.title,
			:created_at => "#{entry.created_at.iso8601}",
			:updated_at => "#{entry.updated_at.iso8601}"
		}

		keywords = entry.keywords.map do |keyword|
			{
				:name => keyword.name,
				:id => keyword.id
			}
		end

		locations = entry.locations.map do |location|
			{
				:id => location.id,
				:name => location.name,
				:lat => location.lat,
				:lat_str => location.lat.to_s,
				:lng => location.lng,
				:lng_str => location.lng.to_s,
			}
		end


		data.merge({ :keywords => keywords, :locations => locations })
	end
end
