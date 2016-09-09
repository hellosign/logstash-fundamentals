# This role constructs an example LogStash box that pulls information from
# various NASA twitter feeds. It contains:
# - LogStash
# - ElasticSearch
# - Kibana
#
class roles::onebox_nasa {

  include profiles::base

  #### Set up the local elasticsearch
  class { 'profiles::onebox_es':
    instance_name => 'onebox_nasa'
  }

  # We need java, this gets it.
  ensure_packages ( 'openjdk-7-jre-headless', { require => Exec['apt_update'] } )

  # Needed later, ensures the given instance is up and running before it
  # passes.
  es_instance_conn_validator { 'onebox_nasa':
    server  => 'localhost',
    port    => '9200',
    require => Elasticsearch::Instance['onebox_nasa'],
    before  => Package['logstash'],
  }

  # Next, set up logstash. Note the use of the 'require'.
  class { 'profiles::logstash':
    require => Es_instance_conn_validator['onebox_nasa']
  }

  include profiles::logstash::output_onebox
  include profiles::logstash::input_nasa_feeds

  # Next, set up Kibana.

  class { 'profiles::kibana_local':
    require => Es_instance_conn_validator['onebox_nasa']
  }

}
