# An input that listens to a redis-list. Used for parsing-nodes
class profiles::logstash::input_redis {

  $redis_ip = hiera('redis_ip', '127.0.0.1')

  logstash::configfile { 'input_redis':
    template => 'profiles/logstash/input/redis',
    order    => 30,
  }

}
