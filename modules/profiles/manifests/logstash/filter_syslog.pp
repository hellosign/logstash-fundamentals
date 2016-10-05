# Deploys a logstash filters for parsing syslog-file entries
class profiles::logstash::filter_syslog {

  logstash::configfile { 'filter_syslog':
    template => 'profiles/logstash/filter/syslog',
    order    => 40,
  }

}
