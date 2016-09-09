# Deploys the apache file-fetcher for Logstash
class profiles::logstash::input_apache.pp {

  logstash::configfile { 'input_apache':
    template => 'profiles/logstash/input/apache',
    order    => 30,
  }

}
