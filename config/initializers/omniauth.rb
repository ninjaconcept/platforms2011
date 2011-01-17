Rails.application.config.middleware.use OmniAuth::Builder do
  
  # dev.twitter.com
  provider :twitter, '521GhE2LbRtkHV9ZwwQ', 'Zscou4OKPdnxNwKbLmq8VDeRGMV9qo0S8ehC6tIbUHE'

  # http://developers.facebook.com/setup/ | http://developers.facebook.com/docs/authentication/
  provider :facebook, '183469038336319', '825193dfd6634d4fe0b2b65199fb62e5'
  
  # provider :linked_in, 'CONSUMER_KEY', 'CONSUMER_SECRET'
  
  # 37signals ID
  # Foursquare
  # GitHub
  # provider :open_id, OpenID::Store::Filesystem.new('/tmp')
end