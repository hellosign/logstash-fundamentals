# Example Complex LogStash File
In this example, we're loading data from N sources, applying several filters,
and outputting it to two different sources. This example includes some organic
cruft! Like a real, live config-file would.


```ruby
# Pull in syslog data
input {
  file {
    path => [
      "/var/log/syslog",
      "/var/log/auth.log"
    ]
    type => "syslog"
  }
}

# Pull in application-log data. They emit data in JSON form.
input {
  file {
    path => [
      "/var/log/app/worker_info.log",
      "/var/log/app/broker_info.log",
      "/var/log/app/supervisor.log"
    ]
    exclude => "*.gz"
    type => "applog"
    codec => "json"
  }
}

# Set up a couple of UDP listeners for network-based logging.
# Perhaps we're experimenting with not logging to files!
input {
  udp {
    port => "8192"
    host => "localhost"
    type => "applog"
    codec => "json"
  }
  udp {
    port => "8193"
    host => "localhost"
    type => "controllog"
    codec => "json"
  }
}

filter {
  # The broad filter on Syslog.
  if [type] == "syslog" {
    grok {
      match => {
        "message" => "%{SYSLOGBASE}%{SPACE}%{GREEDYDATA:SYSLOGMESSAGE}"
      }
    }
    
    # Turn the log timestamp into a true event timestamp.
    date {
      match => [ "timestamp", "MMM  d HH:mm:ss", "MMM dd HH:mm:ss" ]
    }
  }
  
  # App-logs are already formatted thanks to JSON, so much less grokking.
  # But we still have to do a few things.
  
  # Parse the timestamp in the network inputs.
  if [type] == "applog" OR [type] == "controllog" {
    date {
      match => [ "info.timestamp", "ISO8601" ]
    }
  }
  
  # Like drop the debug lines in the info feeds.
  if [type] == "applog" AND [info][message] =~ "^DEBUG:" {
    drop {}
  }
  
  # Parse the metrics data encoded in a field.
  if [type] == "applog" AND [info][message] =~ "^metrics: " {
    grok {
      match => {
        "info.message" => "metrics: %{GREEDYDATA:metrics_raw}"
      }
      tag => [ "metrics" ]
    }
  }
  
  # Parse that key-value field we just found. And drop the 'raw' field.
  if "metrics" in [tags] {
    kv {
      source => "metrics_raw"
      target => "metrics"
      remove_field => "metrics_raw"
    }
  }
  
  if ([type] == "applog" OR [type] == "controllog") AND [supervisor][event_type] == "auth" {
    mutate {
      add_tag => [ "audit" ]
    }
  } else {
    mutate {
      add_tag => [ "logline" ]
    }
  }
}

# Finally, the outputs
output {

  if "logline" in [tags] {
    elasticsearch {
      hosts => [
        "localhost",
        "logelastic.prod.internal"
      ]
      template_name => "logstash"
      index => "logstash-{+YYYY.MM.dd}"
    }
  } else if "audit" in [tags] {
    elasticsearch {
      hosts => [
        "localhost",
        "logelastic.prod.internal"
      ]
      template_name => "audit"
      index => "audit-{+xxxx.ww}"
    }
  }
  
  if "metrics" in [tags] {
    influxdb {
      host => "influx.prod.internal"
      db => "logstash"
      measurement => "appstats"
      # This next bit only works because it is already a hash.
      data_points => "%{metrics}"
    }
  }
}

```