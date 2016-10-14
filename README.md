# Logstash Fundamentals
This repo is intended to be a learning tool for [Logstash by Elastic.co](https://www.elastic.co/guide/en/logstash/current/index.html).
The examples here should get you familiar with the basic structure of Logstash,
and on the way to a working proof-of-concept.

This uses [Puppet 3.8](https://docs.puppet.com/puppet/3.8/reference/) for provisioning
the vagrant boxes. The intent is to also show how Logstash could be managed through
a configuration management product, and to break down the installation components.
By using modules from Puppet Forge, this allows quick setup.

## Requirements

* Vagrant version 1.7 or newer.
* Virtual Box, or VMware Fusion.
* At least 10GB of free disk-space for boxes.
* Internet connection capable of downloading ~300MB (Java and Logstash/ElasticSearch packages) each vagrant run without you losing interest.

## Setup
All of the demos use an Ubuntu Trusty (14.04) box. You will need Linux skills
to move around the filesystem and examine files.

### Linux and Mac
1. Clone this repo.
1. While in the repo, run `./prep_environment`
 * This will checkout the submodules and copy the Hiera details to the parent directory, where Vagrant will use them.
 * This was done to allow you to make your own changes without worrying about committing secrets.

### Windows
1. Clone this repo.
1. While in the repo, run `git submodule init`, or equivalent.
1. Then run, `git submodule update`, or equivalent.
1. Copy the `puppet-hiera` directory to the parent directory of this repo.
 * This allows Vagrant to use it for its work, and to allow you to make your own changes without worrying about committing secrets.

## License
```
The MIT License (MIT)

Copyright (C) 2016 hellosign.com

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

