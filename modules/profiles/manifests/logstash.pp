# Installs the base logstash. Config-items will be handled in other profiles.
# Example: logstash::configfile { 'get_tweetstream': }
class profiles::logstash (
  $run_as_root = false,
  $workers = false,
  $ls_heap = '256m'
) {

  if $run_as_root {
    $ls_user  = 'root'
    $ls_group = 'root'
  } else {
    $ls_user  = 'logstash'
    $ls_group = 'logstash'
  }

  if $workers {
    $ls_opts = '-w 1'
  } else {
    $ls_opts = "-w ${workers}"
  }

  $config_hash = {
    'LS_USER'      => $ls_user,
    'LS_GROUP'     => $ls_group,
    'LS_OPTS'      => $ls_opts,
    'LS_HEAP_SIZE' => $ls_heap
  }

  class { '::logstash':
    manage_repo   => true,
    repo_version  => '2.4',
    init_defaults => $config_hash
  }

}
