# Outputs logstash to a given IP address, instead of locally.
class profiles::logstash::output_escluster {

  $escluster_ip = hiera('escluster_ip', '127.0.0.1')

  logstash::configfile { 'output_direct_es':
    template => 'profiles/logstash/output/escluster',
    order    => 50,
  }

}
