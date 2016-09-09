# Deploys the Logstash input for pull syslog file data.
class profiles::logstash::input_syslog_file {

  logstash::configfile { 'input_syslog_file':
    template => 'profiles/logstash/input/syslog_file',
    order    => 30,
  }

}
