# Installs a network facing elasticsearch that does everything
class profiles::escluster (
  $instance_name = logstash
) {

  include profiles::elastic_key

  # We need java, this gets it.
  ensure_packages ( 'openjdk-8-jre-headless', { require => Exec['apt_update'] } )

  # Get the 'half of RAM' number, to be used as the heap-size for ElasticSearch.
  # Why half? The other half is used for block-cache.
#  $heap_size = inline_template("<%= (@memorysize_mb.to_f / 2).to_i %>")
  $heap_size = $memory['system']['available_bytes'] / 2

  # This construct is needed to tell elasticsearch "Bind where we can see you".
  # This can't be 0.0.0.0 because this address is advertised.
  $es_config = {
    'network' => {
      'host' => $networking['interfaces']['enp0s8']['ip']
    }
  }

  # Installs the elasticsearch base install, but not an instance.
  class { 'elasticsearch':
#    version      => '5.4.1',
    manage_repo  => false,
    repo_version => '5.x',
    api_protocol => 'http',
    config       => $es_config,
    jvm_options  => [
      "-Xms${heap_size}",
      "-Xmx${heap_size}"
    ],
    require      => Exec['apt_update']
  }

  # Installs a specific instance. This puppet module allows installing multiple
  # ES instances on the same host. 'service elasticsearch-logstash stop' will
  # stop it.
  elasticsearch::instance { $instance_name: }

}
