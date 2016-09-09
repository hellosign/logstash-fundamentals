# Ensure curator is installed
class profiles::curator {

  ensure_packages ( 'python-pip', { require => Exec['apt_update'] } )

  class { '::curator':
    bin_file => '/usr/local/bin/curator',
    require  => Package['python-pip']
  }

}
