# Threading Example: Parallelized
In this example logstash config, care has been taken to ensure that
multiple threads can be used for maximum throughput. Compare it to
[the singlethreaded version](examples/threading_example_singlethread.md).

```perl
input {
  file {
    path => [ '/var/log/applogs/*.log' ]
    tags => [ 'applogs' ]
  }
}

input {
  file {
    path => [ '/var/log/debuglogs/*.log' ]
    tags => [ 'applogs', 'debuglogs' ]
  }
}

input {
  file {
    path => [ '/var/log/syslog' ]
    tags => [ 'syslog' ]
  }
}

input {
  file {
    path => [ '/var/log/apache2/*.log' ]
    tags => [ 'apache' ]
  }
}

output {
  elasticsearch {
    hosts => [ 'elastic.prod.internal' ]
  }
}

output{  
  # use IAM credentials to bypass credential-in-cleartext problem.
  s3 {
    bucket => "mycorp_logging_bucket"
    size_file => 1024
    time_file => 10
  }
}

```

## Questions:

* How does performance differ between logstash 1.5 and 2.2 and higher? 
* Does the lack of a filter-stage affect performance?
