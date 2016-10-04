# Creates a stub of the apache log-files, without actually installing apache.
class profiles::apache_stub {

  file {
    '/var/log/apache2':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755';
   '/var/log/apache2/vhosts':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755';
   '/var/log/apache2/vhosts/sysadmin1138-net.log':
      ensure => present,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      before => Service['logstash'];
   '/var/log/apache2/vhosts/sysadmin1138-net.basis':
      ensure  => present,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      source  => 'puppet:///modules/profiles/apache/sysadmin1138-net.basis',
      require => Package['logstash'],
      before  => Service['logstash'];
  }

  # This sneakiness is to ensure this log-file is parsed by logstash.
  # Don't do this in prod, kids.
  exec { 'Wait 30s for logstash to launch': 
    command => 'sleep 1',
    path    => [ '/usr/bin', '/bin', '/usr/sbin' ],
    notify  => Exec['dumplogs'],
    require => [ Service['logstash'], File['/var/log/apache2/vhosts/sysadmin1138-net.basis'] ],
  }

  exec { 'dumplogs':
    command     => "sleep 30; bzcat /var/log/apache2/vhosts/sysadmin1138-net.basis >> /var/log/apache2/vhosts/sysadmin1138-net.log",
    path        => [ '/usr/bin', '/bin', '/usr/sbin' ],
    refreshonly => true,
  }

}
