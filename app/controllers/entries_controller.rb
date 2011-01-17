class EntriesController < ApplicationController
	layout "default"

	def index
		@page_title = t("entries.newest")
		@entries = Entry.all

		respond_to do |format|
			format.html
		end
	end

	def show
		@entry = Entry.find_by_id(params[:id])
		if @entry
			@page_title = @entry.title
		else
			# 404
		end
	end
end
