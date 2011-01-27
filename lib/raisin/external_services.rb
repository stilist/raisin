module Raisin
	module ExternalServices
		require "crack/json"
		require "open-uri"

		class Utilities
			# Call an API.
			#
			# Options:
			#     `:path` -- required, string; base path
			#          (e.g. `http://google.com`)
			#     `:params` -- optional, hash; hash of arguments for query string
			#          (e.g. `{ :page => 3, :per_page => 25 }`)
			#     `:headers` -- optional, hash
			#          (e.g. `{ "Accept" => "application/json" }`)
			#
			# Note: Some modules may use their own `api_call` method instead of this
			# one (e.g. Twitter, which performs everything via the `twitter_oauth` gem.
			def api_call(options = {})
				begin
					url = options[:path] << "?"

					if options[:params]
						url << options[:params].map { |k,v| "#{k}=#{v}"}.join("&")
					end

					headers = { "User-Agent" => "Raisin Lifestream" }
					headers.merge!(options[:headers]) if options[:headers]

					data = open(url, headers).read

					data_format = options[:format] || :json

					case data_format
					when :json then Crack::JSON.parse(data)
					when :xml then Crack::XML.parse(data)
					when :none then data
					end
				rescue OpenURI::HTTPError => the_error
					puts "\n\nERROR: #{the_error.message}\n\n"
				end
			end

			# Generate an unsaved `Entry` record.
			#
			# `:title`, `:body`, and `:bookmark_url` can be `nil` or `String`.
			# `:created_at` and `:updated_at` can be any of `nil`, `Date`,
			# `DateTime`, or `Time`.
			def generate_entry(options = {})
				entry = Entry.new
				entry.title = options[:title] || "(untitled)"
				entry.body = options[:body] || nil
				entry.bookmark_url = options[:bookmark_url] || nil
				entry.created_at = options[:created_at] || Time.now
				entry.updated_at = options[:updated_at] || TIme.now

				entry
			end

			def get_items(options = {})
				
			end

			# Get timestamp of a service's most recent data import.
			#
			# Options:
			#     `:service_name`: required, string
			#         (e.g. `"YouTube"`)
			def last_updated(options = {})
				last_import = LastImport.first({
						:conditions => { :service_name => options[:service_name] }})
				last_import ? last_import.timestamp : nil
			end
		end
	end
end
