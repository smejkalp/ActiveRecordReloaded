# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ActiveRecordReloaded_session',
  :secret      => '0b482a51ff703447cca81ffde6347bfab19c1a576e7cb6f7110bc96f7ef7ff2dfc3f3ad680517527fa2d746df55bddd85d9c412de304a0e3793cbaf5313da3c8'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
