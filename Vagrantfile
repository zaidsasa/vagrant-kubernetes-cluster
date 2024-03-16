require "yaml"
vagrant_root = File.dirname(File.expand_path(__FILE__))

settings = YAML.load_file "#{vagrant_root}/settings.yaml"
k8s_settings = settings["k8s"]

Vagrant.configure("2") do |config|

  controlplane_settings = settings["vm"]["controlplane"]

  config.vm.define "controlplane" do |controlplane|
    controlplane.vm.hostname = "controlplane"
    controlplane.vm.box = "generic/ubuntu2204"

    controlplane.vm.provider "virtualbox" do |vb|
      vb.cpus = controlplane_settings["cpu"]
      vb.memory = controlplane_settings["memory"]
    end

    controlplane.vm.synced_folder "ansible/", "/vagrant/ansible", SharedFoldersEnableSymlinksCreate: false
    controlplane.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "ansible/controlplane.yml"
      ansible.inventory_path = "ansible/inventory.ini"
      ansible.become = true
      ansible.extra_vars = {
        k8s_version: k8s_settings["version"]
      }
    end

  end

  worker_settings = settings["vm"]["workers"]

  (1..worker_settings["count"]).each do |i|
    config.vm.define "node0#{i}" do |worker|
      worker.vm.hostname = "node0#{i}"
      worker.vm.box = "generic/ubuntu2204"

      worker.vm.provider "virtualbox" do |vb|
        vb.cpus = worker_settings["cpu"]
        vb.memory = worker_settings["memory"]
      end

      worker.vm.synced_folder "ansible/", "/vagrant/ansible", SharedFoldersEnableSymlinksCreate: false
      worker.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "ansible/worker.yml"
        ansible.inventory_path = "ansible/inventory.ini"
        ansible.become = true
        ansible.extra_vars = {
          k8s_version: k8s_settings["version"]
        }
      end

    end

  end

end
