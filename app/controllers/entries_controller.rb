class EntriesController < ApplicationController
	layout "default"

	def index
		@page_title = t("entries.newest")
		@entries = Entry.all({ :order => "created_at DESC", :limit => 50,
				:include => [:keywords, :locations] })
#		@activity = monthly_keyword_activity(@entries)

		respond_to do |format|
			format.html
			format.json
		end
	end

	def show
		@entry = Entry.find_by_id(params[:id], :include => [:locations])
		if @entry
			@page_title = @entry.title
		else
			# 404
		end
	end
end
