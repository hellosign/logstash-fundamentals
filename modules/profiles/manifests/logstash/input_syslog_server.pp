# Runs the 'syslog' input for logstash
class profiles::logstash::input_syslog_server {

  logstash::configfile { 'input_syslog_server':
    template => 'profiles/logstash/input/syslog_server',
    order    => 30,
  }

}
