# Installs a network facing elasticsearch that does everything
class profiles::escluster (
  $instance_name = logstash
) {

  include profiles::elastic_key

  # We need java, this gets it.
  ensure_packages ( 'openjdk-7-jre-headless', { require => Exec['apt_update'] } )

  # Install ElasticSearch repo, because the elasticsearch module doesn't do
  # a good job of that.
  apt::source { 'elasticsearch':
    ensure   => present,
    location => "http://packages.elastic.co/elasticsearch/2.x/debian",
    release  => 'stable',
    repos    => 'main',
    include  => {
      'source' => false
    },
    require  => Apt::Key['elastic'],
    notify   => Exec['apt_update']
  }

  # Get the 'half of RAM' number, to be used as the heap-size for ElasticSearch.
  # Why half? The other half is used for block-cache.
  $heap_size = inline_template("<%= (@memorysize_mb.to_f / 2).to_i %>")

  # This construct is needed to tell elasticsearch "Bind where we can see you".
  # This can't be 0.0.0.0 because this address is advertised.
  $es_config = {
    'network' => {
      'host' => "${::ipaddress_eth1}"
    }
  }

  # Installs the elasticsearch base install, but not an instance.
  class { 'elasticsearch':
    manage_repo  => false,
    repo_version => '2.x',
    api_protocol => 'http',
    config       => $es_config,
    require      => Exec['apt_update']
  }

  # Installs a specific instance. This puppet module allows installing multiple
  # ES instances on the same host. 'service elasticsearch-logstash stop' will
  # stop it.
  elasticsearch::instance { $instance_name:
    init_defaults => {
      'ES_HEAP_SIZE' => "${heap_size}m"
    }
  }

}
