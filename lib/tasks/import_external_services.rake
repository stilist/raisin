namespace :import_external_services do
	RAILS_ROOT = ENV["RAILS_ROOT"] || File.dirname(__FILE__) + "/../.."
	CONFIG_FILE = RAILS_ROOT + "/config/external_services.yml"
	if File.exist?(CONFIG_FILE) && File.ftype(CONFIG_FILE) == "file"
		SERVICES_CONFIG = YAML.load_file(CONFIG_FILE)
	else
		abort "\n\nPlease edit config/external_services.yml.example and save it as external_services.yml\n\n"
	end

	desc "Import checkins from Gowalla"
	task :gowalla => :environment do
		if SERVICES_CONFIG && SERVICES_CONFIG["gowalla"]
			puts "Importing from Gowalla..."
			gowalla = Raisin::ExternalServices::Gowalla.new
			gowalla.config = SERVICES_CONFIG["gowalla"]
			gowalla.import
		else
			abort "\n\nPlease add your Gowalla API information to config/external_services.yml\n\n"
		end
	end

	desc "Import bookmarks from Pinboard"
	task :pinboard => :environment do
		if SERVICES_CONFIG && SERVICES_CONFIG["pinboard"]
			puts "Importing from Pinboard..."
			pinboard = Raisin::ExternalServices::Pinboard.new
			pinboard.config = SERVICES_CONFIG["pinboard"]
			pinboard.import
		else
			abort "\n\nPlease add your Pinboard login information to config/external_services.yml\n\n"
		end
	end

	desc "Import statuses from Twitter"
	task :twitter => :environment do
		if SERVICES_CONFIG && SERVICES_CONFIG["twitter"]
			puts "Importing from Twitter..."
			twitter = Raisin::ExternalServices::Twitter.new
			twitter.config = SERVICES_CONFIG["twitter"]
			twitter.config_file = CONFIG_FILE
			twitter.import
		else
			abort "\n\nPlease add your Twitter API information to config/external_services.yml\n\n"
		end
	end

	desc "Import statuses from Twitter API dump"
	task :twitter_static => :environment do
		twitter = Raisin::ExternalServices::TwitterStatic.new
		twitter.import
	end

	desc "Import favorites from YouTube"
	task :youtube => :environment do
		if SERVICES_CONFIG && SERVICES_CONFIG["youtube"]
			puts "Importing from YouTube..."
			youtube = Raisin::ExternalServices::Youtube.new
			youtube.config = SERVICES_CONFIG["youtube"]
			youtube.import
		else
			abort "\n\nPlease add your YouTube API information to config/external_services.yml\n\n"
		end
	end

	desc "Import data from all known external services. Schedule this task."
	task :all => [:gowalla, :pinboard, :twitter, :youtube] do
	end
end
