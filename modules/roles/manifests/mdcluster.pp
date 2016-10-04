# Creates a combined elasticsearch/redis cluster.
# Don't do this in prod!
class roles::mdcluster {

  include profiles::base
  include profiles::escluster
  include profiles::logredis

  # Running as root to read the syslog file.
  # However, if you add the 'logstash' user to the 'adm' group,
  # you can read these files normally. Exercise for the reader.
  class { 'profiles::logstash':
    run_as_root => true,
  }

  # Read from the redis list, as this is a parser node.
  include profiles::logstash::input_redis

  # Fetch the local syslog, since we do that.
  include profiles::logstash::input_syslog_file

  # Include appropriate filters for all that we do.
  include profiles::logstash::filter_syslog_file
  include profiles::logstash::filter_apache
  # Since this IS the ES box, output to itself.
  include profiles::logstash::output_escluster


}
