# Outputs to the escluster box for larger environments
class profiles::logstash::output_escluster {

  $escluster_ip = hiera('escluster_ip', '127.0.0.1')

  logstash::configfile { 'output_escluster':
    template => 'profiles/logstash/output/escluster',
    order    => 50,
  }

}
