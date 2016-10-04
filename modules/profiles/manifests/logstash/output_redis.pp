# Outputs to a redis server for queuing
class profiles::logstash::output_redis {

  $redis_ip = hiera('redis_ip', '127.0.0.1')

  logstash::configfile { 'output_redis':
    template => 'profiles/logstash/output/redis',
    order    => 50,
  }


}
