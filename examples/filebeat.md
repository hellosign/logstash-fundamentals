# FileBeat Examples
[FileBeat is part of the Beats framework, designed to replace the `file` input
on logstash](https://www.elastic.co/guide/en/beats/filebeat/current/index.html).
Here are a couple of examples of FileBeat configurations.

```yaml
filebeat:
  prospectors:
    -
      paths:
        - "/var/log/syslog"
        - "/var/log/auth.log"
      input_type: log
      document_type: syslog
    -
      paths:
        - "/var/log/apache2/*.log"
      input_type: log
      document_type: apache
output:
  logstash:
    hosts: [ "prodstash.prod.internal:5044" ]

```
This configuration monitors two system logfiles, setting their LogStash type to
be `syslog`, and monitors apache logs, setting their LogStash type to `apache`.
Completed events are then sent to a LogStash instance running the `beats` input
on port 5044.

```yaml
filebeat:
  prospectors:
    -
      paths:
        - "/var/log/syslog"
        - "/var/log/auth.log"
        input_type: log
        document_type: syslog
    -
      paths:
        - "/var/log/app/api_callback*"
        input_type: log
        document_type: applog
        exclude_files: [ '\.gz$' ]
        exclude_lines: [ '^DEBUG:.*' ]
        fields:
          application: "myapp"
          app_component: "callbacks"
    -
      paths:
        - "/var/log/app/workers/*.log"
        input_type: log
        document_type: applog
        exclude_files: [ '\.gz$' ]
        exclude_lines: [ '^DEBUG:.*' ]
        fields:
          application: "myapp"
          app_component: "workers"
  output:
    redis:
      host: "logredis.prod.internal:6379"
      index: "filebeat_prod"
```
This more complex example pulls some system log information, like the above
example, but also pulls in some application-specific logs. It then uses FileBeat
filters to configure it to reject `DEBUG` loglines, and not parse logfiles that
have been gzipped. It then adds appropriate fields to the events. This uses the 
redis output, dumping events into the `filebeat_prod` key.
