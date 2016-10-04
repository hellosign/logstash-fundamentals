# The base defines for the various node-types.

node default {

  case $::node_type {
    'onebox_nasa':   { include roles::onebox_nasa }
    'onebox_syslog': { include roles::onebox_syslog }
    'apache':        { include roles::apache }
    'escluster':     { include roles::escluster }
    'mdcluster':     { include roles::mdcluster }
  }

}
