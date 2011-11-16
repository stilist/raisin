module Raisin
	module ExternalServices
		# https://github.com/jnunemaker/crack/issues/26
		YAML::ENGINE.yamler = "syck"

		require "crack/json"
		require "open-uri"

		class Utilities
			# Call an API.
			#
			# Options:
			# `:path` -- required, string; base path (e.g. `http://google.com`)
			# `:params` -- optional, hash; hash of arguments for query string (e.g.
			#   `{ :page => 3, :per_page => 25 }`)
			# `:headers` -- optional, hash (e.g.
			#   `{ "Accept" => "application/json" }`)
			#
			# Note: Some modules may use their own `api_call` method instead of this
			# one (e.g. Twitter, which performs everything via the `twitter_oauth`
			# gem.
			def api_call options = {}
				settings = {
					:format => :json,
					:headers => {},
					:params => {},
					:path => ""
				}.merge(options)

				begin
					{ "User-Agent" => "Raisin Lifestream" }.merge(settings[:headers])

					settings[:path] << "?#{settings[:params].to_param}"
					data = open(settings[:path], settings[:headers]).read

					case settings[:format]
					when :json then Crack::JSON.parse data
					when :xml then Crack::XML.parse data
					else data
					end
				rescue OpenURI::HTTPError => the_error
					puts "\n\nERROR: #{the_error.message}\n\n"
				end
			end

			# Generate and hand back an unsaved `Entry` record.
			#
			# `:title`, `:body`, and `:bookmark_url` can be `nil` or `String`.
			# `:created_at` and `:updated_at` can be any of `nil`, `Date`,
			# `DateTime`, or `Time`.
			def generate_entry options = {}
				settings = {
					:bookmark_url => nil,
					:body => nil,
					:created_at => Time.now,
					:title => "(untitled)",
					:updated_at => Time.now
				}.merge(options)

				Entry.new settings
			end

			def get_items options = {} ; end

			# Get timestamp of a service's most recent data import.
			#
			# Options:
			#     `:service_name`: required, string
			#         (e.g. `"YouTube"`)
			def last_updated options = {}
				last_import = LastImport.
						where(:service_name => options[:service_name]).
						first
				last_import ? last_import.timestamp : nil
			end
		end
	end
end
