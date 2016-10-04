# Sets up the logstash environment for an Apache server, outputting
# to a variety of things, based on environment.
class roles::apache {

  include profiles::base
  include profiles::apache_stub
  include profiles::kibana_network

  # Running as root to read the syslog file.
  # However, if you add the 'logstash' user to the 'adm' group,
  # you can read these files normally. Exercise for the reader.
  class { 'profiles::logstash':
    run_as_root => true,
  }

  include profiles::logstash::input_syslog_file
  include profiles::logstash::input_apache
  include profiles::logstash::filter_syslog_file
  include profiles::logstash::filter_apache
  case $::env_type {
    'small':  { include profiles::logstash::output_escluster }
    'medium': { include profiles::logstash::output_redis }
    default:  { include profiles::logstash::output_escluster }
  }

}
