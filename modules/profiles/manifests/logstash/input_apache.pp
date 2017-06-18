# Deploys the apache file-fetcher for Logstash
class profiles::logstash::input_apache {

  logstash::configfile { '30-input_apache':
    content => template('profiles/logstash/input/apache'),
  }

}
