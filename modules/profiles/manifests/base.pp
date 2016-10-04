# Provides the base modifications that need to happen on all nodes.
class profiles::base {

  include apt

  case $::virtual {
    'xenu':   {
      $vm_user = 'ubuntu'
    }
    'virtualbox':  {
      $vm_user = 'vagrant'
    }
    default:  {
      $vm_user = 'ubuntu'
    }
  }

  file { [  "/home/${vm_user}/.bash_aliases",
            '/root/.bash_aliases' ]:
    owner   => $vm_user,
    group   => $vm_user,
    mode    => '0640',
    content => template('profiles/base/bash_aliases'),
  }

  # Provide vim syntax hilighting for classes.
  file { '/usr/share/vim/vim74/syntax/hcl.vim':
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    source => 'puppet:///modules/profiles/base/hcl.vim',
  }

}
