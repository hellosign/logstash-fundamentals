# vi: set syntax=ruby 
Vagrant.require_version ">= 1.7.0"

# Create some happy little VMs to demo on.

small_environment = {
  :escluster => '192.168.99.10',
  :apache    => '192.168.99.20'
}

medium_environment = {
  :mdcluster => '192.168.99.10',
  :apache  => '192.168.99.20'
}

Vagrant.configure("2") do |config|

  # Define the base box we want to play with, and some always-on-everything
  # items.
  config.vm.box = 'ubuntu/trusty64'
  config.vm.provision "shell", :path => "vup"
  # Define the Hiera directory
  # Use this for your own.
  config.vm.synced_folder "../puppet-hiera", "/etc/puppet-hiera"
  # Use this for the repo's version of hiera
  # config.vm.synced_folder "hiera/" "/etc/puppet-hiera"

  puppet_common = proc do |puppet|
    puppet.manifests_path = "manifests"
    puppet.manifest_file  = "site.pp"
    puppet.module_path    = "modules"
    puppet.hiera_config_path = "hiera.yaml"
    puppet.working_directory = "/tmp/vagrant-puppet"
    puppet.options = "--environment=prod" # --verbose --debug --trace"
  end

  config.vm.define :onebox_nasa do |onebox_nasa|
    onebox_nasa.vm.hostname = 'oneboxnasa'
    onebox_nasa.vm.network "private_network", ip: "192.168.99.20"
    onebox_nasa.vm.provision :puppet do |puppet|
      puppet_common.call(puppet)
      puppet.facter = {
        "node_type"      => 'onebox_nasa',
        "hostname"       => 'onebox_nasa'
      }
    end
    onebox_nasa.vm.provider :virtualbox do |vb|
      vb.memory = '1256'
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    end
    onebox_nasa.vm.provider :vmware_fusion do |vb|
      vb.vmx["memsize"] = '1256'
      vb.vmx["numvcpus"] = 2
    end
  end

  config.vm.define :onebox_syslog do |onebox_syslog|
    onebox_syslog.vm.hostname = 'oneboxsyslog'
    onebox_syslog.vm.network "private_network", ip: "192.168.99.20"
    onebox_syslog.vm.provision :puppet do |puppet|
      puppet_common.call(puppet)
      puppet.facter = {
        "node_type"      => 'onebox_syslog',
        "hostname"       => 'onebox_syslog'
      }
    end
    onebox_syslog.vm.provider :virtualbox do |vb|
      vb.memory = '1256'
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
    end
    onebox_syslog.vm.provider :vmware_fusion do |vb|
      vb.vmx["memsize"] = '1256'
      vb.vmx["numvcpus"] = 2
    end
  end

  # This iterator builds the Vagrant definitions for all of the small_environment
  # machines, defined at the top.
  small_environment.keys.each do |node_name|
    config.vm.define "small_#{node_name}" do |node|
      node.vm.hostname = "#{node_name}"
      node.vm.network :private_network, ip: small_environment[node_name]
      node.vm.provision :puppet do |puppet|
        puppet_common.call(puppet)
        puppet.facter = {
          "node_type"  => "#{node_name}",
          "env_type"   => "small"
        }
      end
      node.vm.provider :virtualbox do |vb|
        vb.memory = '1256'
        vb.cpus = '2'
        vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
      end
      node.vm.provider :vmware_fusion do |vb|
        vb.vmx["memsize"] = '1024'
        vb.vmx["numcpus"] = 2
      end
    end
  end

  # This iterator builds the Vagrant definitions for all of the medium_environment
  # machines, defined at the top.
  medium_environment.keys.each do |node_name|
    config.vm.define "medium_#{node_name}" do |node|
      node.vm.hostname = "#{node_name}"
      node.vm.network :private_network, ip: medium_environment[node_name]
      node.vm.provision :puppet do |puppet|
        puppet_common.call(puppet)
        puppet.facter = {
          "node_type"  => "#{node_name}",
          "env_type"   => "medium"
        }
      end
      node.vm.provider :virtualbox do |vb|
        vb.memory = '1256'
        vb.cpus = '2'
        vb.customize ["modifyvm", :id, "--nictype1", "virtio"]
      end
      node.vm.provider :vmware_fusion do |vb|
        vb.vmx["memsize"] = '1024'
        vb.vmx["numcpus"] = 2
      end
    end
  end

end
