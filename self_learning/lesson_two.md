# Logstash configuration file
The Logstash configuration file is where you define all of your inputs, filters,
and outputs. Out of the box this will be located in:

* `/etc/logstash/conf.d/` on Unix-like operating systems that install from packages.
* `/usr/share/logstash/config/` for docker images.
* `{unzip-path}\config\` on Windows.

All in all, the format of the file is pretty simple.

```perl
input { }
filter { }
output { }
```
Like all simple things, it can get really complex. First of all, each of those blocks
can be declared multiple times. Those blocks can be interleved with each other.
Blocks can contain one or more plugin declarations. If you don't pay attention,
this can get unmaintainably messy. To help with that, here are some rules of thumb:

* Define your `input { }` blocks before your `filter { }` blocks.
* Define your `filter { }` blocks together.
* The order of your `filter { }` blocks matters.
* Your `output { }` blocks should be after the `input { }` blocks.

As Logstash is multi-threaded, it pays to be aware of how threads work with Logstash.
Each `input { }` block will get its own thread. Multiple plugins can run in the same
`input { }` block and thread, or you can put each plugin into a different `input { }`
block and their I/O won't block each other.

The `filter { }` and `output { }` blocks are run inside `pipeline threads`. The number
of pipeline threads is defined at startup through the `-w` command-line parameter.
By default (as of version 5.0) the number of threads is set to 8. If you're running
Logstash on a 2 CPU AWS instance, you'll probably want to reduce that number. If
you're running it on a 36 core monster-box, you can increase it by lots.

[Much more detail about the threading model, and it's history, can be found in the logstash documentation][ls-threading].

We've spoken about the file, so [let's look at an example.][single-thread] Open it in another tab.

In there you can see the structure of a simple Logstash config. It has a `file { }`
plugin configured to monitor several application log-files, as well as syslog.
A single `filter { }` block uses the `mutate { }` filger plugin to add tags to
events based on the path the event came from. Finally the `output {} block has
two plugins to send data to ElasticSearch, and also an AWS S3 bucket.

[ls-threading]: https://www.elastic.co/guide/en/logstash/current/fault-tolerance.html
[single-thread]: ../examples/threading_example_singlethread.md
