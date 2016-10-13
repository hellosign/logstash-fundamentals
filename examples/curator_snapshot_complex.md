# Two Curator examples. A snapshot-yesterday example, and a snapshot-hourly.

This takes advantage of the fact that this generates a crontab entry,
and uses a bash call to figure out what yesterday's index would be
named. That way you don't have to keep snapshotting the full history
of indexes, just the one that just stopped changing.
```yaml
actions:
  1:
    action: snapshot
    description: Snapshot the yesterday index for onebox.
    options:
      repository: logstash_backup
      name: onebox-%Y.%m.%d
    filters:
      - filtertype: pattern
        kind: prefix
        value: 'onebox-'
      - filtertype: age
        source: name
        timestring: %Y.%m.%d
        direction: older
        unit: days
        unit_count: 1
      - filtertype: count
        count: 1
        reverse: True
```
This works by filtering on the pattern (`onebox-`) to get just the indices we
care about. Then by filtering on the age of the index, to get the list of indices
older than a day. Finally, we pull exactly one index out, which is the newest
index in that list of old indexes.

This next example, an hourly snapshot is taken of the 'audit' index, and
a second job delete the old ones. To make it interesting, the 'audit' index
rotates weekly, not daily.

```yaml
actions:
  1:
    action: snapshot
    description: Hourly snapshot of the audit index
    options:
      repository: logstash_backup
      name: houraudit-%Y%m%d%H
    filters:
      - filtertype: pattern
        kind: timestring
        value: '%G.%V'
      - filtertype: pattern
        kind: prefix
        value: 'audit-'
  2:
    action: delete_snapshot
    description: Remove old hourly snapshots of the audit index
    options:
      repository: logstash_backup
    filters:
      - filtertype: pattern
        kind: prefix
        value: 'hraudit-'
      - filtertype: age
        source: creation_date
        direction: older
        unit: hours
        unit_count: 26
```
Then another one to snapshot it after the next week has started. As these have
a seven year retention period (ick), there is no snapshot-removal step.

```yaml
actions:
  1:
    action: snapshot
    description: Snapshot the last-week index for audit
    options:
      repository: logstash_backup
      name: audit-%G.%V
    filters:
      - filtertype: pattern
        kind: prefix
        value: 'audit-'
      - filtertype: age
        source: name
        timestring: %G.%V
        direction: older
        unit: weeks
        unit_count: 1
      - filtertype: count
        count: 1
        reverse: True

```
These would be launched through cron. The executions would look something like:

```shell
/usr/local/bin/curator --config /etc/curator/curator.yml /etc/curator/snap_audit-hourly.yml
/usr/local/bin/curator --config /etc/curator/curator.yml /etc/curator/snap_audit-weekly.yml
```
