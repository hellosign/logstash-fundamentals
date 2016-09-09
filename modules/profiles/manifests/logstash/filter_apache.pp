# Deploys the apache-log parsing filter for logstash
class profiles::logstash::filter_apache {

  logstash::configfile { 'filter_apache':
    template => 'profiles/logstash/filter/apache',
    order    => 40,
  }

}
