# Threading Example: Single threaded
In this example logstash config, little care has been taken for the threading
model. Compare it to 
[the parallelized version](examples/threading_example_parallel.md).

```ruby
input {
  file {
    path => [
      '/var/log/applogs/*.log',
      '/var/log/debuglogs/*.log',
      '/var/log/syslog',
      '/var/log/apache2/*.log'
    ]
  }
}

filter {
  if [path] =~ '/var/log/applogs' {
    mutate {
      add_tag => [ 'applogs' ]
    }
  } else if [path] =~ '/var/log/debuglogs' {
    mutate {
      add_tag => [ 'applogs' 'debuglogs' ]
    }
  } else if [path] =~ '/var/log/apache' {
    mutate {
      add_tag => [ 'apache' ]
    }
  } else if [path] =~ '/var/log/syslog' {
    mutate {
      add_tag => [ 'syslog' ]
    }
  }
}

output {
  elasticsearch {
    hosts => [ 'elastic.prod.internal' ]
  }
  
  # use IAM credentials to bypass credential-in-cleartext problem.
  s3 {
    bucket => "mycorp_logging_bucket"
    size_file => 1024
    time_file => 10
  }
}

```