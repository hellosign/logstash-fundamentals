# Turns the box into an all-in-one ElasticSearch box.
class roles::escluster {

  include profiles::base

  # We need java, this gets it.
  ensure_packages ( 'openjdk-7-jre-headless', { require => Exec['apt_update'] } )

  # Get the 'half of RAM' number, to be used as the heap-size for ElasticSearch.
  # Why half? The other half is used for block-cache.
  $heap_size = inline_template("<%= (@memorysize_mb.to_f / 2).to_i %>")

  # Installs the elasticsearch base install, but not an instance.
  class { 'elasticsearch':
    manage_repo  => true,
    repo_version => '2.x',
    api_host     => 'localhost',
    api_protocol => 'http',
  }

  # Installs a specific instance. This puppet module allows installing multiple
  # ES instances on the same host. 'service elasticsearch-logstash stop' will
  # stop it.
  elasticsearch::instance { 'logstash':
    init_defaults => {
      'ES_HEAP_SIZE' => "${heap_size}m"
    }
  }

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
