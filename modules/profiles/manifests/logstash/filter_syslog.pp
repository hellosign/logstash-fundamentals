# Deploys a logstash filters for parsing syslog-file entries
class profiles::logstash::filter_syslog {

  logstash::configfile { '40-filter_syslog':
    content => template('profiles/logstash/filter/syslog'),
  }

}
