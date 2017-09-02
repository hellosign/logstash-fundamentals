# This uses the twitter input to gather a bunch of NASA twitter feeds.
class profiles::logstash::input_nasa_feeds {

  $logstash_twitter           = lookup( 'logstash::twitter', { merge => deep, default_value => {} } )
  $twitter_consumer_key       = $logstash_twitter['consumer_key']
  $twitter_consumer_secret    = $logstash_twitter['consumer_secret']
  $twitter_oauth_token        = $logstash_twitter['oauth_token']
  $twitter_oauth_token_secret = $logstash_twitter['oauth_token_secret']
  $nasa_keywords              = $logstash_twitter['keywords']

  logstash::configfile { '30-input_nasa_feeds':
    content => template('profiles/logstash/input/nasa_feeds'),
  }

}
