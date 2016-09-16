# Two Curator examples. A snapshot-yesterday example, and a snapshot-hourly.

This takes advantage of the fact that this generates a crontab entry,
and uses a bash call to figure out what yesterday's index would be
named. That way you don't have to keep snapshotting the full history
of indexes, just the one that just stopped changing.
```puppet
  curator::job { 'onebox_snapshot_yesterday':
    command     => 'snapshot',
    index       => 'onebox-$(/bin/date -u +"\\%Y.\\%m.\\%d" --date "yesterday")',
    snapshot    => 'onebox-$(/bin/date -u +"\\%Y.\\%m.\\%d" --date "yesterday")',
    repository  => 'logstash_backup',
    cron_hour   => 1,
    cron_minute => 02,
  }

```

This next example, an hourly snapshot is taken of the 'audit' index, and
a second job delete the old ones. To make it interesting, the 'audit' index
rotates weekly, not daily.

```puppet
  # Snapshot weekly index at 19 minutes after the hour.
  curator::job { 'audit_snapshot_hourly':
    command     => 'snapshot',
    index       => 'audit-$(/bin/date -u +"\\%G.\\%V")',
    snapshot    => 'houraudit-$(/bin/date -u +"\\%Y\\%m\\%d\\%H")',
    repository  => 'logstash_backup',
    cron_minute => 19,
  }

  # Snapshot weekly index once it is inactive.
  curator::job { 'audit_snapshot_weekly':
    command      => 'snapshot',
    index        => 'audit-$(/bin/date -u +"\\%G.\\%V" --date "yesterday")',
    snapshot     => 'audit-$(/bin/date -u +"\\%G.\\%V" --date "yesterday")',
    repository   => 'logstash_backup',
    cron_weekday => 0,
    cron_hour    => 3
    cron_minute  => 33,
  }

  # Remove old hourly snapshots at 27 minutes after the hour.
  # Removes snapshots older than 26 hours.
  curator::job { 'audit_delete_hourly':
    command     => 'delete',
    prefix      => 'houraudit-',
    timestring  => '\\%Y\\%m\\%d\\%H',
    time_unit   => 'hours',
    older_than  => 26,
    cron_minute => 27,
  }
```
