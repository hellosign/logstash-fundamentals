# Deploys the Logstash input for pull syslog file data.
class profiles::logstash::input_syslog_file {

  logstash::configfile { '30-input_syslog_file':
    content => template('profiles/logstash/input/syslog_file'),
  }

}
