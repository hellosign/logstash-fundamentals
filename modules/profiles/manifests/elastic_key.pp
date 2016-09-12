# Installs the elasticsearch GPG key for apt, to avoid dependency cycles.
class profiles::elastic_key {

  apt::key { 'elastic':
      id     => '46095ACC8548582C1A2699A9D27D666CD88E42B4',
      source => 'http://packages.elasticsearch.org/GPG-KEY-elasticsearch'
  }

}
