# Deploys the apache-log parsing filter for logstash
class profiles::logstash::filter_apache {

  logstash::configfile { '40-filter_apache':
    content => template('profiles/logstash/filter/apache'),
  }

}
