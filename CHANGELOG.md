# Changelog

## v0.1.0 [2016-10-16]

#### Release Notes
Initial release, shipped with the LISA 2016 tutorial USB key.

This release contains definitions for the following Vagrant boxes:

* `onebox_nasa`: An all-in-one box to demo the twitter logstash integration, with Kibana.
* `onebox_syslog`: An all-in-one box to demo a syslog-server, with curator and Kibana.
* `small_escluster`: An all-in-one ElasticSearch cluster-box, with minimal on-box Logstash.
* `small_apache`: An emulated Apache server, with logstash, that ships data to the `small_escluster` box. With Kibana.
* `medium_mdcluster`: A combined ElasticSearch cluster-box with, redis, and complex Logstash parsing rules.
* `medium_apache`: Like `small_apache`, but only ships events to the redis server on `medium_mdcluster`. Hosts Kibana.

At this time, this repo supports the following versions of Elastic products:

* **Logstash**: 2.4
* **ElasticSearch**: 2.4
* **Kibana**: 4.6
* **Curator**: 4.1.2

ElasticStack 5.0 is in beta, and not yet supported by all of the puppet components.
As a result, 5 is not yet implemented here. By the time of the LISA conference,
this support may have been added in.
