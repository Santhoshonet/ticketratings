# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_TicketRatings_session',
  :secret      => '5978d37d6f37a3a0d2ab2cabf702095ae3c4fe04e00ca3de001c79660864783dc99caab883cfe62b3948bd73707a6198f7de9f5fd3c94e9ed3e5dcd25f7ee5d6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
