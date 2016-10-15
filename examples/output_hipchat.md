# Example Output for HipChat
Sends a notice to HipChat when a type of queue gets clogged.

```ruby
output {
  if [queue_size] > 30 AND [queue_name] =~ "system_*" {
    hipchat {
      room_id        => "12932"
      token          => "secrets"
      from           => "%{queue_name}"
      format         => "This queue has %{queue_size} jobs in it. It probably needs a good kicking."
      color          => "yellow"
      trigger_notify => true
    }
  }
}

```

This one sends a notice when a backup is finished.
```ruby
output {
  if [backup_status] == "finished" {
    hipchat {
      room_id => "12932"
      token   => "secrets"
      from    => "backup_events"
      format  => "The backup job %{backup_job_id} on %{backup_node} has finished with %{backup_size/1024}GB in the VTL."
      color   => "green"
    }
  }
}
```
