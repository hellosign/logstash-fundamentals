# Turns the box into an all-in-one ElasticSearch box.
class roles::escluster {

  include profiles::base
  include profiles::escluster

  # Running as root to read the syslog file.
  # However, if you add the 'logstash' user to the 'adm' group,
  # you can read these files normally. Exercise for the reader.
  class { 'profiles::logstash':
    run_as_root => true,
  }

  include profiles::logstash::input_syslog_file
  include profiles::logstash::filter_syslog_file
  # Since this IS the ES box, output to itself.
  include profiles::logstash::output_escluster

}
