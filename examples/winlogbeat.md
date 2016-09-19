# WinLogBeat Examples
[WinLogBeat is part of the Beats framework, designed to replace the `eventlog` input
on logstash](https://www.elastic.co/guide/en/beats/winlogbeat/current/_overview.html).
Here are a couple of examples of FileBeat configurations.

```yaml
winlogbeat:
  registry_file: C:/ProgramData/winlogbeat/.winlogbeat.yml

  event_logs:
    - name: ForwardedEvents
      

output:
  logstash:
    hosts: [ "prodstash.prod.internal:5044" ]

```
This configuration monitors the 'ForwardedEvents' event-log, outputting to a
LogStash instance running the `beats` input on port 5044. The ForwardedEvents
event-log is where a system configured to [forward events](https://msdn.microsoft.com/en-us/library/bb870973(v=vs.85).aspx)
deposits its logs. This can be useful if you are not allowed to install
WinLogBeat on your Domain Controllers.

