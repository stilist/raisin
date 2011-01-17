class KeywordsController < ApplicationController
	layout "default"

	def show
		@keyword = Keyword.find_by_id(params[:id])
		if @keyword
			@page_title = t("keywords.entries_for_keyword",
				{ :keyword => @keyword.name })
			@entries = @keyword.entries({ :include => [:keyword] })
		else
			# 404
		end
	end
end
