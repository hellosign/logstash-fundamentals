# Example Complex LogStash File
In this example, we're loading data from N sources, applying several filters,
and outputting it to two different sources.


```perl
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

# Pull in application-log data
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

input {
  udp {
    port => "8192"
    host => "localhost"
    type => "applog"
  }
  udp {
    port => "8193"
    host => "localhost"
    type => "controllog"
  }
}
```