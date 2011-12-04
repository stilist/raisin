namespace :import_external_services do
	desc "Import checkins from Gowalla"
	task :gowalla => :environment do
		puts "Importing Gowalla..."
		gowalla = Raisin::ExternalServices::Gowalla.new
		gowalla.import
	end

	desc "Import checkins from Pinboard"
	task :pinboard => :environment do
		puts "Importing Pinboard..."
		pinboard = Raisin::ExternalServices::Pinboard.new
		pinboard.import
	end

	desc "Import checkins from Twitter"
	task :twitter => :environment do
		puts "Importing Twitter..."
		twitter = Raisin::ExternalServices::Twitter.new
		twitter.import
	end

	desc "Import checkins from YouTube"
	task :youtube => :environment do
		puts "Importing YouTube..."
		youtube = Raisin::ExternalServices::Youtube.new
		youtube.import
	end

	# TODO
	desc "Import statuses from Twitter API dump"
	task :twitter_static => :environment do
		twitter = Raisin::ExternalServices::TwitterStatic.new
		twitter.import
	end

	desc "Import data from all known external services. Schedule this task."
	task :all => [:gowalla, :pinboard, :twitter, :youtube] do
	end
end
