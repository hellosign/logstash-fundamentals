# Installs the onebox elasticsearch server and instance.
class profiles::onebox_es (
  $instance_name = 'logstash'
) {

  include profiles::elastic_key

  ensure_packages ( 'openjdk-8-jre-headless', {
    require => Exec['apt_update'],
  } )

  # Installs the elasticsearch base install, but not an instance.
  class { 'elasticsearch':
    version      => '5.4.1',
    manage_repo  => false,
    repo_version => '5.x',
    api_host     => 'localhost',
    api_protocol => 'http',
    jvm_options  => [
      '-Xms512m',
      '-Xmx512m'
    ],
    require      => Exec['apt_update'],
  }

  # Installs a specific instance. This puppet module allows installing multiple
  # ES instances on the same host. 'service elasticsearch-onebox_nasa stop' will
  # stop it.
  elasticsearch::instance { $instance_name: }

  # Needed later, ensures the given instance is up and running before it
  # passes.
#  es_instance_conn_validator { $instance_name:
#    server  => 'localhost',
#    port    => '9200',
#    require => [ Elasticsearch::Instance[$instance_name] ],
#  }

}
