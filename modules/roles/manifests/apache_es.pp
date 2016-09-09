# Sets up the logstash environment for an Apache server, outputting
# to an ElasticSearch box somewhere off-box.
class roles::apache_es {

  include profiles::base

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
  include profiles::logstash::output_direct_es

}
