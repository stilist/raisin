# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

	# expects an array of `Entry` objects
	#
	# note: for efficiency, make sure your ActiveRecord query for the entries
	# uses `:include => :keywords`
	def monthly_keyword_activity keyword_ids
		longest_streak = 0

		keyword_options = { :order => "name ASC", :include => :entries }
		unless keyword_ids == :all 
			keyword_options.merge!({ :conditions => { :id => keyword_ids } })
		end
		keywords = Keyword.all(keyword_options)

		activity = keywords.map do |keyword|
			entries = keyword.entries.all({ :order => "created_at ASC" })

			if entries.empty?
				nil
			else
				grouped_by_month = entries.group_by do |entry|
					entry.created_at.beginning_of_month
				end

				if grouped_by_month.count > longest_streak
					longest_streak = grouped_by_month.count
				end

				{
					:color => keyword.color,
					:counts => grouped_by_month.map { |month, entries| entries.count },
					:id => keyword.id,
					:name => keyword.name
				}
			end
		end

		{
			:activity => activity.compact,
			:longest_streak => longest_streak,
		}
	end
end
