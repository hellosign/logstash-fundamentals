# Outputs to a redis server for queuing
class profiles::logstash::output_redis {

  $redis_ip = lookup('redis_ip', { default_value => '127.0.0.1' } )

  logstash::configfile { '50-output_redis':
    content => template('profiles/logstash/output/redis'),
  }

}
