class EntriesController < ApplicationController
	layout "default"

	def index
		@page_title = t("entries.newest")
		@entries = Entry.page params[:page]
		# @activity = monthly_keyword_activity @entries
	end

	def show
		@entry = Entry.where(:id => params[:id]).joins([:locations]).first
		if @entry
			@page_title = @entry.title
		else
			# 404
		end
	end
end
