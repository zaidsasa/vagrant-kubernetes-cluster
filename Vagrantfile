require "yaml"

vagrant_root = File.dirname(File.expand_path(__FILE__))

settings = YAML.load_file "#{vagrant_root}/settings.yaml"
k8s_settings = settings["k8s"]

Vagrant.configure("2") do |config|

  controlplane_settings = settings["vm"]["controlplane"]

  config.vm.define "controlplane" do |controlplane|
    controlplane.vm.hostname = "controlplane"
    controlplane.vm.box = controlplane_settings["box"]

    controlplane.vm.provider "virtualbox" do |vb|
      vb.cpus = controlplane_settings["cpu"]
      vb.memory = controlplane_settings["memory"]
    end

    controlplane.vm.network "private_network", type: "dhcp"
    controlplane.vm.synced_folder "ansible/", "/vagrant/ansible", SharedFoldersEnableSymlinksCreate: false
    controlplane.vm.synced_folder ".tmp/", "/vagrant/tmp", create: true

    controlplane.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "ansible/controlplane.yml"
      ansible.inventory_path = "ansible/inventory.ini"
      ansible.extra_vars = {
        k8s_version: k8s_settings["version"],
        k8s_network_pod_cidr: k8s_settings["network"]["pod_cidr"],
        k8s_network_pod_service: k8s_settings["network"]["pod_service"]
      }
    end

  end

  worker_settings = settings["vm"]["workers"]

  (1..worker_settings["count"]).each do |i|
    config.vm.define "node0#{i}" do |worker|
      worker.vm.hostname = "node0#{i}"
      worker.vm.box = worker_settings["box"]

      worker.vm.provider "virtualbox" do |vb|
        vb.cpus = worker_settings["cpu"]
        vb.memory = worker_settings["memory"]
      end

      worker.vm.network "private_network", type: "dhcp"
      worker.vm.synced_folder "ansible/", "/vagrant/ansible", SharedFoldersEnableSymlinksCreate: false
      worker.vm.synced_folder ".tmp/", "/vagrant/tmp", create: true

      worker.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "ansible/worker.yml"
        ansible.inventory_path = "ansible/inventory.ini"
        ansible.extra_vars = {
          k8s_version: k8s_settings["version"],
          k8s_network_pod_cidr: k8s_settings["network"]["pod_cidr"],
          k8s_network_pod_service: k8s_settings["network"]["pod_service"]
        }
      end

    end

  end

  # TODO: Add trigger on destroy to delete .tmp folder

end
