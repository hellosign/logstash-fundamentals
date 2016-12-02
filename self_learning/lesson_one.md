# Lesson One: Logstash Pipeline
Logstash is a form of ETL pipeline.

* **Extract** - Pull data out of something, or have data pushed to it.
* **Transform** - Manipulate the ingested data.
* **Load** - Publish the manipulated data in some kind of backing storage.

The name derives from its original goal of processing log-files produced by
applications, and saving them in a way that you can then query. There are
many for-profit applications that allow you to do this, but an open source
alternative is very attractive. Since then it has expanded into a more general
purpose pipeline, allowing you to do things like extract twitter hashtags.

The pipeline is similar to the ETL stages, but named differently.
![Logstash Pipleine][pipeline]

[Logstash has many input plugins available][ls-input]. The name 'logstash' suggests
that the [file plugin][input-file] is something it should have, and it does.
If you're dealing with file-based data, this is the input that allows you to
ingest it. It can do far more, though. Here is a small sampling of input plugins,
and how they can be used:

* **tcp** and **udp**: These open a network port. Any text sent to it will be ingested as a single event. Handy if you're trying to avoid writing to a filesystem.
* **github**: This allows you to listen to GitHub webhooks.
* **twitter**: This leverages the Twitter streaming APIs to get a feed of twitter messages.
* **kafka**, **rabbitmq**, and **zeromq**: Pulls events off of a queuing system.
* **irc** and **xmpp**: Monitor chatrooms. Useful if you need to make your chatroom a *business record*, or want to perform analytics on a support channel.

We'll be going over these more intensly in [lesson three][L3].

The next stage on the pipeline is filters. [As with inputs, there are many filter plugins][ls-filter].
These allow you to enrich your data; everything from tagging events based on where
they came from, to parsing inline JSON to get user-defined fields on your
events. If you're using log-aggregation through Syslog, filters allow you to
specify program-specific parsers for log-events. These also allow you to
keep *DEBUG* events from hitting your long term storage. These will be covered
in depth in [lesson five][L5]

Once your data has been massaged to your satisfaction,
[the output plugins allow you to send it to many different places at the same time][ls-output].
The one thing it can't do natively is send to an RDBMS like MySQL or Postgres. It's
a philosophical thing. By design, Logstash does not enforce a schema on the
events it processes; dumping into a strictly enforced environment is problematic
enough that it is left as an exercise for the implementer. We'll be going in
depth on these in [lesson six][L6]

[Continue to the next lesson, on the configuration file.][L2]

[pipeline]: http://sysadmin1138.net/images/LogstashPipeline.svg
[ls-input]: https://www.elastic.co/guide/en/logstash/current/input-plugins.html
[ls-filter]: https://www.elastic.co/guide/en/logstash/current/filter-plugins.html
[ls-output]: https://www.elastic.co/guide/en/logstash/current/output-plugins.html
[input-file]: https://www.elastic.co/guide/en/logstash/current/plugins-inputs-file.html
[L2]: lesson_two.md
[L3]: lesson_three.md
[L5]: lesson_five.md
