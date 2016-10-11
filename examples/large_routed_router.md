# Large Routed - Router
This example configuration shows what the logstash routing-tier could look
like in an environment that has a routing tier.

```ruby
input {
  kafka {
    zk_connect => "keeper1.devops.internal:9092,keeper2.devops.internal:9092"
    topic_id   => "logstash_ingest"
  }
}

filter {
  if [type] == "syslog" and ( [source] == "/var/log/auth.log" or [source] == "/var/log/audit/audit.log" ) {
    mutate {
      add_tag => [ "audit" ]
    }
  }

  if [type] == "audit" {
    mutate {
      add_tag => [ "audit" ]
    }
  }
}

output {
  if "audit" in [tags] {
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
