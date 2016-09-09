# Installs the onebox elasticsearch server and instance.
class profiles::onebox_es (
  $instance_name
) {


  # Installs the elasticsearch base install, but not an instance.
  class { 'elasticsearch':
    manage_repo  => true,
    repo_version => '2.x',
    api_host     => 'localhost',
    api_protocol => 'http',
  }

  # Installs a specific instance. This puppet module allows installing multiple
  # ES instances on the same host. 'service elasticsearch-onebox_nasa stop' will
  # stop it.
  elasticsearch::instance { $instance_name: }

}
