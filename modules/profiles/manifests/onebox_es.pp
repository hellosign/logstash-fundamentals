# Installs the onebox elasticsearch server and instance.
class profiles::onebox_es (
  $instance_name = 'logstash'
) {

  include profiles::elastic_key

  ensure_packages ( 'openjdk-7-jre-headless', {
    require => Exec['apt_update'],
  } )

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

  # Installs the elasticsearch base install, but not an instance.
  class { 'elasticsearch':
    manage_repo  => false,
    repo_version => '2.x',
    api_host     => 'localhost',
    api_protocol => 'http',
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
