# Creates a redis server for use with logstash.
class profiles::logredis {

  apt::ppa { 'ppa:chris-lea/redis-server': }

  class { 'redis' :
    bind           => '0.0.0.0',
    service_ensure => 'running',
    package_name   => 'redis-server',
    require        => Exec['apt_update']
  }

  # Part of hotrodding Redis is to set vm.overcommit_memory to 1.
  file_line { 'redis_overcommit':
    path   => '/etc/sysctl.conf',
    line   => 'vm.overcommit_memory = 1',
    notify => Exec['vm_overcommit'],
  }

  exec { 'vm_overcommit':
    command     => 'sysctl vm.overcommit_memory=1',
    path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
    refreshonly => true
  }

  # The next is to set transparent_hugepage to never, as this has a severe
  # impact on performance when redis is loaded.
  ini_subsetting { 'set-grub-hugepages':
    ensure     => present,
    path       => '/etc/default/grub',
    setting    => 'GRUB_CMDLINE_LINUX',
    subsetting => 'transparent_hugepage',
    value      => "=never",
    notify     => Exec['update-grub-hugepages'],
  }

  exec { 'update-grub-hugepages':
    command     => '/usr/sbin/update-grub',
    refreshonly => true,
    notify      => Exec['onetime-hugepages'],
  }

  exec { 'onetime-hugepages':
    command     => 'echo never > /sys/kernel/mm/transparent_hugepage/enabled',
    path        => ['/sbin', '/usr/sbin', '/bin', '/usr/bin'],
    refreshonly => true,
  }

}
