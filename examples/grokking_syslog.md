# Grokking Syslog
In this example, we progressively build some syslog grokking. We are looking
for output from backup scripts. The output of the scripts is well known, which
allows us to build some simple grok expressions and give our events rich data
to work with.

It all begins with syslog parsing. This is taken from [one of the filters we use in vagrant builds](modules/profiles/templates/logstash/filter/syslog_file)

```perl
filter {
  if [type] == "syslog-file" {
    # Syslog parsing is handled through Grok.
    # Documentation: https://www.elastic.co/guide/en/logstash/2.4/plugins-filters-grok.html
    grok {
      # This will create a new field called SYSLOGMESSAGE, that contains the 
      # data part of a syslog line.
      #
      # If given a line like:
      # Sep  9 19:09:50 ip-192-0-2-153 dhclient: bound to 192.0.2.153 -- renewal in 1367 seconds.
      # SYSLOGMESSAGE will equal "bound to 192.0.2.153 -- renewal in 1367 seconds."
      #
      match => {
        "message" => "%{SYSLOGBASE}%{SPACE}%{GREEDYDATA:SYSLOGMESSAGE}"
      }
    }
  }
}
```
This will give us a variety of fields to work with, such as:

* `program`: The program that issued the log-line.
* `pid`: The PID of the program.
* `logsource`: The machine that recorded the message.
* `SYSLOGMESSAGE`: The message-part of the syslog line