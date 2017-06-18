# Runs the 'syslog' input for logstash
class profiles::logstash::input_syslog_server {

  logstash::configfile { '30-input_syslog_server':
    content => template('profiles/logstash/input/syslog_server'),
  }

}
