# Installs Kibana, in local mode with no proxies.
class profiles::kibana_local {

  class { '::kibana':
    ensure => '5.4.1',
    config => {
      'server.port'       => 3010,
      'server.host'       => $networking['interfaces']['enp0s8']['ip'],
      'elasticsearch.url' => 'http://localhost:9200',
    }
  }

}
