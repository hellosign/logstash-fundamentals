# Ensure curator is installed
class profiles::curator (
  $elastic_host = '127.0.0.1'
) {

  apt::source { 'curator':
    ensure   => present,
    location => "http://packages.elastic.co/curator/4/debian",
    release  => 'stable',
    repos    => 'main',
    include  => {
      'source' => false
    },
    require  => Apt::Key['elastic'],
    notify   => Exec['apt_update']
  }

  ensure_packages ( 'elasticsearch-curator', { require => Exec['apt_update'] } )

  file {
    '/etc/curator':
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0750';
    '/etc/curator/curator.yml':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
      content => template('profiles/curator/config.yml');
  }
}
