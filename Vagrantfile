# -*- mode: ruby -*-
# vi: set ft=ruby :
#

Vagrant.configure(2) do |config|
  # Disable insecure key replacement
  #config.ssh.insert_key = false
  #
  # Use your id_rsa key from ~/.ssh
  config.ssh.private_key_path = [ '~/.vagrant.d/insecure_private_key', '~/.ssh/id_rsa' ]
  config.ssh.forward_agent = true
  config.vm.box = "flannon/centos_6.7_min"
  config.vm.provider "virtualbox" do |vb|
    #vb.gui = true
    #vb.memory = "2048"
  end
  config.vm.network "forwarded_port", guest:  3306, host: 3406
  config.vm.network "forwarded_port", guest:  8080, host: 8180
  config.vm.network "forwarded_port", guest:  8081, host: 8181
  config.vm.network "forwarded_port", guest:  8089, host: 8189
  config.vm.network "forwarded_port", guest:  8090, host: 8190
  config.vm.network "forwarded_port", guest:  8091, host: 8191
  config.vm.hostname = "archivesspace.local"
  config.vm.provision "shell", path: "bin/init-puppet-centos6.sh"
  config.vm.provision "shell", path: "bin/load-mpapis-sig.sh"
  config.vm.provision "shell", path: "bin/load-known_hosts.sh"

  config.librarian_puppet.puppetfile_dir = "puppet"
  config.librarian_puppet.placeholder_filename = ".MYPLACEHOLDER"
  config.librarian_puppet.use_v1_api = '1' 
  config.librarian_puppet.destructive = false 

  config.vm.provision "puppet" do |puppet|
      #puppet.module_path = [ 'puppet/modules', 'puppet/modules-local' ]
      puppet.module_path = [ 'puppet/modules' ]
      puppet.manifests_path = "puppet/manifests"
      puppet.hiera_config_path = "puppet/hiera.yaml"
      puppet.working_directory = "/tmp/vagrant-puppet"
      puppet.manifest_file = "default.pp"
  end
  config.vm.provision "shell", path: "bin/update-git.sh"
  #config.vm.provision "shell", path: "bin/load-asdb.sh"

end
