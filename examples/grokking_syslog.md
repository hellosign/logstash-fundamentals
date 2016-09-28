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

If we are given some log-lines such as these:

```
May 19 19:22:06 ip-172-16-2-4 pii-repo-backup[4982]: ALARM Unable to isolate framulator, backup not taken.
May 20 07:01:02 ip-172-16-2-4 pii-repo-backup[5122]: OK Hourly backup success.
```

We can construct patterns to match these. We already know that `SYSLOGMESSAGE`
will be set to `ALARM Unable to isolate framulator, backup not taken.` So let's
construct a pattern to extract the meaningful information.

A good tool for figuring out how to grok this is [grokdebug.herokuapp.com](http://grokdebug.herokuapp.com/).
It allows you to paste in a log-line, and progressively build your expression.
Remember, you can name your fields by using either `%{PATTERN:field_name}` or
`(?<field_name>regex)`. Use the former if you're using a built in pattern, the
latter, if you're building your own regex.

A simple capture for these events could be this:
```perl
%{WORD:backup_state} %{GREEDYDATA:backup_message}
```
It's not all that efficient, but it gets the job done. However, the internal
standard for backup-output has only a few states defined. A more targeted capture
would look like this:
```perl
(?<backup_state>OK|WARN|ALARM|CRIT) %{GREEDYDATA:backup_message}
```
We can now start building our Grok expression.

For best efficiency, we need to place this Grok expression *after* the above expression.
This allows us to filter on a specific field and reduce the per-cycle computational
overhead. Since we know all of our backup scripts end with "-backup":
```perl
if [program] =~ "-backup$" {
  grok {
    match => {
      "SYSLOGMESSAGE" => "(?<backup_state>OK|WARN|ALARM|CRIT) %{GREEDYDATA:backup_message}"
      "program" => "%{GREEDYDATA:backup_name}-backup"
    }
    add_tag => [ "backup_output" ]
  }
}
```
The conditional looks for strings ending with `-backup`, and then applies the
grok expression to it. We use two matches; one on `SYSLOGMESSAGES` to pull out the
`backup_state` and `backup_message` fields, and a second on the `program` field
to pull out the `backup_name` field. Finally, we tag the event with `backup_output`
for use later on and to ease finding the event in reporting.

* `backup_name`: pii-repo
* `backup_state`: ALARM
* `backup_message`: Unable to isolate framulator, backup not taken.
* `tags`: [ "backup_output" ]
* `type`: syslog
 
---

With fields defined in this way, we can use them for outputs:
```perl
output {
  if "backup_output" in [tags] AND [backup_state] != "OK" {
    pagerduty {
      service_key => "secrets"
      event_type => "trigger"
      incident_key => "logstash/%{backup_name}/%{backup_state}"
      description => "Backup failure on %{backup_name}. RPO is not being met."
      details => "%{backup_state}: %{backup_message}"
    }
  }
}
```
Which will issue a PagerDuty incident in the event of a failed backup. The
fields we populated in the grok expression are used to provide information in the
incident. This usage would be much harder if we had to extract the text we wanted
from within large fields.