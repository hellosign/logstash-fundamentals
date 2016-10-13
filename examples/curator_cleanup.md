# Curator Cleanup
In this example, old indices and snapshots are cleaned up from the ElasticSearch cluster.

```yaml
actions:
  1:
    action: delete_indices
    description: "Removes logstash indices older than 28 days."
    filters:
      - filtertype: pattern
        kind: prefix
        value: logstash-
      - filtertype: age
        source: name
        timestring: '%Y.%m.%d'
        direction: older
        unit: days
        unit_count: 28
  2:
    action: delete_snapshot
    description: "Remove logstash backups older than 6 months"
    options:
      repository: logstash_backup
    filters:
      - filtertype: pattern
        kind: prefix
        value: 'logstash-'
      - filtertype: age
        source: creation_date
        direction: older
        unit: months
        unit_count: 6
```

