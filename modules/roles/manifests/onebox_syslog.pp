# This role constructs an example LogStash box that pulls information from
# various NASA twitter feeds. It contains:
# - LogStash
# - ElasticSearch
# - Kibana
#
class roles::onebox_syslog {

  include profiles::base

  #### Set up the local elasticsearch
  class { 'profiles::onebox_es':
    instance_name => 'onebox_syslog'
  }

  # We need java, this gets it.
  ensure_packages ( 'openjdk-7-jre-headless', { require => Exec['apt_update'] } )

  ## Next, set up logstash. Note the use of the 'require'.
  #  Unlike onebox_nasa, we need to run as root in order to bind
  #  UDP/514, so we're setting run_as_root = true.
  class { 'profiles::logstash':
    run_as_root => true,
  }

  include profiles::logstash::output_onebox
  include profiles::logstash::input_syslog_server

  # Next, set up Kibana.

  class { 'profiles::kibana_local':
  }

  # Next, get Curator set up

  include profiles::curator

  # Remove onebox indexes older than a week.
  curator::job { 'onebox_delete':
    command     => 'delete',
    prefix      => 'onebox-',
    older_than  => '7',
    cron_hour   => '03',
    cron_minute => '05',
  }

  # This is what a weekly index would look like.
  # We're not using it here, this is just for example.
  # curator::job { 'onebox_delete_weekly':
  #   command      => 'delete',
  #   prefix       => 'onebox-',
  #   timestring   => '\%G.\%V',
  #   time_unit    => 'weeks',
  #   older_than   => '2',
  #   cron_hour    => 1,
  #   cron_minute  => 02,
  #   cron_weekday => 3,
  # }
  # WARNING: curator uses python strftime for timestring, not joba!

}
