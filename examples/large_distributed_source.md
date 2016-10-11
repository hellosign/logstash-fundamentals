# Large Distributed Source
This example configuration shows what a logstash configuration on a log-producing
node might look like in a large, distributed environment.

```ruby
input {
  file {
    paths => [ "/var/log/syslog" ]
    type  => "syslog"
  }
  file {
    paths => [
      "/var/log/auth.log",
      "/var/log/audit/audit.log"
    ]
    type => "audit"
  }
}

input {
  file {
    paths => [ "/var/log/product-a/*.log" ]
    type  => "product-a"
  }
  file {
    paths => [ "/var/log/product-q/*.log" ]
    type  => "product-q"
  }
}

output {
  if [type] == "audit" {
    redis {
      host      => [ "audit.security.internal" ]
      data_type => "list"
      key       => "audit_log"
    }
  } else {
    kafka {
      broker_list => "keeper1.devops.internal:9092,keeper2.devops.internal:9092"
      topic_id    => "%{type}"
    }
  }
}
```    

