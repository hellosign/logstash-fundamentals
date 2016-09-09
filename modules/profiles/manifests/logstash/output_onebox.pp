# Outputs to the local ES repo for onebox installs.
class profiles::logstash::output_onebox {

  logstash::configfile { 'output_onebox_es':
    template => 'profiles/logstash/output/onebox_es',
    order    => 50,
  }

}
