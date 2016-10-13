# Sets up a curator job
define profiles::curator_job (
  $jobfile,
  $cron_weekday = '*',
  $cron_hour    = 1,
  $cron_minute  = 10,
) {

  $clean_name = shell_escape($name)

  file { "/etc/curator/${clean_name}.yml":
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => $jobfile,
  }

  cron { $name:
    command => "/usr/local/bin/curator --config /etc/curator/curator.yml /etc/curator/${clean_name}.yml",
    user    => 'root',
    weekday => $cron_weekday,
    hour    => $cron_hour,
    minute  => $cron_minute,
  }


}
