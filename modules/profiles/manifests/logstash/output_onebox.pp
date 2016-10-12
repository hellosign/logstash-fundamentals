# Outputs to the local ES repo for onebox installs.
class profiles::logstash::output_onebox {

  # Because onebox uses an index named something other than 'logstash', we
  # have to import our own template. This copies the template-file to the
  # local file-system, and the configfile fragment will use that to 
  # update the ES Cluster templates. New indices will get those mappings.

  file { '/etc/logstash/logstash.json':
    owner   => 'logstash',
    group   => 'logstash',
    source  => 'puppet:///modules/profiles/logstash/templates/onebox.json',
    require => Logstash::Configfile ['output_onebox_es'],
    notify  => Service['logstash'],
  }

  logstash::configfile { 'output_onebox_es':
    template => 'profiles/logstash/output/onebox_es',
    order    => 50,
  }

}
