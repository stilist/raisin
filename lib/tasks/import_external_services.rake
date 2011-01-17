namespace :import_external_services do
	RAILS_ROOT = ENV["RAILS_ROOT"] || File.dirname(__FILE__) + "/../.."
	CONFIG_FILE = RAILS_ROOT + "/config/external_services.yml"
	if File.exist?(CONFIG_FILE) && File.ftype(CONFIG_FILE) == "file"
		SERVICES_CONFIG = YAML.load_file(CONFIG_FILE)
	else
		abort "\n\nPlease edit config/external_services.yml.example and save it as external_services.yml\n\n"
	end

	desc "Import user data from Gowalla"
	task :gowalla => :environment do
		if SERVICES_CONFIG && SERVICES_CONFIG["gowalla"]
			gowalla = Raisin::ExternalServices::Gowalla.new
			puts "Importing from Gowalla..."

			last_import = LastImport.first({
					:conditions => { :service_name => "Gowalla" }})
			last_updated = last_import ? last_import.timestamp : nil
			options = SERVICES_CONFIG["gowalla"].merge(
					{ "last_updated" => last_updated })

			gowalla.options = options
			gowalla.import
		else
			abort "\n\nPlease add your Gowalla API information to config/external_services.yml\n\n"
		end
	end

	desc "Import data from all known external services"
	task :all => [:gowalla] do
	end
end
