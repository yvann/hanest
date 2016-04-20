# -*- mode: ruby -*-
# vi: set ft=ruby :

parameters = {
  "node_count" => 3,
  "node_hostname_prefix" => "handev",
  "node_ip_start" => "192.168.100.10",
  "node_memory" => 1024,
  "node_cpus" => 1
}

Vagrant.configure(2) do |config|
  config.vm.box = "hanest/node"
  config.vm.box_url = "file://hanest/packer/hanest-node-virtualbox.box"

  config.ssh.username = "hanest"
  config.ssh.password = "theperfectnestforyourcontainers"
  config.ssh.insert_key = true

  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/vagrant", disabled: true

  config.hostmanager.enabled = true
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = false
  config.hostmanager.include_offline = false
  config.hostmanager.ip_resolver = proc do |vm, _resolving_vm|
      `VBoxManage guestproperty get #{vm.id} '/VirtualBox/GuestInfo/Net/1/V4/IP'`.split[1] if vm.id
  end

  hostvars, nodes = {}, []

  (1..parameters["node_count"]).each do |n|
    hostname = "%s%02d" % [parameters["node_hostname_prefix"], n]
    ip = parameters["node_ip_start"] + "#{n}"
    last = (n >= parameters["node_count"])

    config.vm.define hostname, primary: last do |node|
      node.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--cpus", parameters["node_cpus"]]
        vb.customize ["modifyvm", :id, "--memory", parameters["node_memory"]]
      end

      node.vm.hostname = hostname
      node.vm.network "private_network", :ip => ip

      nodes << hostname
      hostvars.merge!({
        hostname => {
          "private_ipv4" => ip,
          "public_ipv4" => ip,
          "role" => "node"
        }
      })

      if last
        node.vm.provision :hostmanager
        node.vm.provision "ansible" do |ansible|
          ansible.playbook = 'hanest/playbooks/node.yml'
          # ansible.raw_arguments = ["-t setup"]
          ansible.limit = 'all'
          ansible.host_vars = hostvars
        end
      end
    end
  end

end
