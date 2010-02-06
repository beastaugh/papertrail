# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_papertrail_session',
  :secret => <<-KEY
  64b8a037826981813ef8829d921f69dc78133bb4bb921516da502ecdfceb575c
  be2ca132e2658bcb6e8326d413f9c41fdf09413403eeb3d92a171b737bc9ded4
KEY
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
