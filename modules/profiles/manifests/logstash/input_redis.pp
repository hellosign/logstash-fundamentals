# An input that listens to a redis-list. Used for parsing-nodes
class profiles::logstash::input_redis {

  $redis_ip = lookup('redis_ip', { default_value => '127.0.0.1' } )

  logstash::configfile { '30-input_redis':
    content => template('profiles/logstash/input/redis'),
  }

}
