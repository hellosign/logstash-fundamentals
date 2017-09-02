# Installs Kibana, in network mode with no proxies.
class profiles::kibana_network {

  $elasticsearch_ip = lookup('escluster_ip', { default_value => 'localhost' } )

  class { '::kibana':
    manage_repo => true,
    config      => {
      'server.port'       => 3010,
      'server.host'       => $networking['interfaces']['enp0s8']['ip'],
      'elasticsearch.url' => "http://${elasticsearch_ip}:9200"
    }
  }

}
