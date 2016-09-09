# Deploys a logstash filters for parsing syslog-file entries
class profiles::logstash::filter_syslog_file {

  logstash::configfile { 'filter_syslog_file':
    template => 'profiles/logstash/filter/syslog_file',
    order    => 40,
  }

}
