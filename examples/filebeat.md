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