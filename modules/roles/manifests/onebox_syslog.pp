# This role constructs an example LogStash box that sets up a syslog-plugin
# based logstash service. It contains:
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
  ensure_packages ( 'openjdk-8-jre-headless', { require => Exec['apt_update'] } )

  ## Next, set up logstash. Note the use of the 'require'.
  #  Unlike onebox_nasa, we need to run as root in order to bind
  #  UDP/514, so we're setting run_as_root = true.
  class { 'profiles::logstash':
    run_as_root => true,
  }

  include profiles::logstash::output_onebox
  include profiles::logstash::input_syslog_server
  include profiles::logstash::input_syslog_file
  include profiles::logstash::filter_syslog

  # Next, set up Kibana.

  class { 'profiles::kibana_local': }

  # Next, get Curator set up

  include profiles::curator

  # Remove onebox indexes older than a week.
  profiles::curator_job { 'onebox_delete':
    jobfile     => template('profiles/curator/onebox_delete.yml'),
    cron_hour   => '3',
    cron_minute => '5',
  }

}
