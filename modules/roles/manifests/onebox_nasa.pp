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

  include profiles::logstash
  include profiles::logstash::output_onebox
  include profiles::logstash::input_nasa_feeds

  # Next, set up Kibana.

  class { 'profiles::kibana_local':
    require => Service['elasticsearch-instance-onebox_nasa']
  }

}
