# Installs Kibana4, in local mode with no proxies.
class profiles::kibana_local {

  class { '::kibana4':
    manage_repo => true,
    config      => {
      'server.port' => 3010
    } 
  }

}
