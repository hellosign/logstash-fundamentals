# Installs Kibana4, in network mode with no proxies.
class profiles::kibana_network {

  $elasticsearch_ip = hiera('escluster_ip', 'localhost')

  class { '::kibana4':
    manage_repo => true,
    config      => {
      'server.port'       => 3010,
      'elasticsearch.url' => "http://${elasticsearch_ip}:9200"
    }
  }

}
