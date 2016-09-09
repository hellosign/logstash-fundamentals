# This uses the twitter input to gather a bunch of NASA twitter feeds.
class profiles::logstash::input_nasa_feeds {

  $logstash_twitter           = hiera( 'logstash::twitter', {} )
  $twitter_consumer_key       = $logstash_twitter['consumer_key']
  $twitter_consumer_secret    = $logstash_twitter['consumer_secret']
  $twitter_oauth_token        = $logstash_twitter['oauth_token']
  $twitter_oauth_token_secret = $logstash_twitter['oauth_token_secret']
  $nasa_keywords              = any2array($logstash_twitter['keywords'])

  logstash::configfile { 'input_nasa_feeds':
    template => 'profiles/logstash/input/nasa_feeds',
    order    => 30,
  }

}
