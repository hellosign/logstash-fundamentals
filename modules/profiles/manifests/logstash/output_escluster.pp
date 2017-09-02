# Outputs logstash to a given IP address, instead of locally.
class profiles::logstash::output_escluster {

  $escluster_ip = lookup('escluster_ip', { default_value => '127.0.0.1' } )

  logstash::configfile { '50-output_direct_es':
    content => template('profiles/logstash/output/escluster'),
  }

}
