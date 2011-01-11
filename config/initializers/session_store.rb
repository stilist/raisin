# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_raisin_session',
  :secret      => '509643f04912880abb0d4b42d65524b0506b1f916d0236df05d65f410c0b112916c98e828beb33d98b7729d0d09d6a4970cddfce7981454270b4eac4b7b92e5d'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
