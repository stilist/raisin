class KeywordsController < ApplicationController
	layout "default"

	def show
		@keyword = Keyword.first({ :conditions => { :id => params[:id] },
				:include => :entries })
		if @keyword
			@page_title = t("keywords.entries_for_keyword",
				{ :keyword => @keyword.name })
			@entries = @keyword.entries.all({ :order => "created_at DESC",
					:limit => 50, :include => [:keywords, :locations] })
			@activity = monthly_keyword_activity(@keyword.id)

			respond_to do |format|
				format.html
			end
		else
			# 404
		end
	end
end
