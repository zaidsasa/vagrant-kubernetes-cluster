require "yaml"

class IPBlocks
  def initialize(cidr)
      ips = []
      for a in 1..10 do
          v = IPAddr.new(cidr)|a
          ips.append(v)  
      end
      @ips = ips
  end

  def GetNewIP()
      return @ips.shift(1)[0].to_s
    end
end

vagrant_root = File.dirname(File.expand_path(__FILE__))

settings = YAML.load_file "#{vagrant_root}/settings.yaml"

ipBlocks = IPBlocks.new(settings["vm"]["network"]["cidr"])

k8s_settings = settings["k8s"]

Vagrant.configure("2") do |config|

  controlplane_settings = settings["vm"]["cluster"]["controlplane"]

  config.vm.define "controlplane" do |controlplane|
    controlplane.vm.hostname = "controlplane"
    controlplane.vm.box = controlplane_settings["box"]

    controlplane.vm.provider "virtualbox" do |vb|
      vb.cpus = controlplane_settings["cpu"]
      vb.memory = controlplane_settings["memory"]
    end

    controlplane.vm.network "private_network", ip: ipBlocks.GetNewIP()
    controlplane.vm.synced_folder "ansible/", "/vagrant/ansible", SharedFoldersEnableSymlinksCreate: false
    controlplane.vm.synced_folder ".tmp/", "/vagrant/tmp", create: true

    controlplane.vm.provision "ansible_local" do |ansible|
      ansible.playbook = "ansible/controlplane.yaml"
      ansible.inventory_path = "ansible/inventory.ini"
      ansible.extra_vars = {
        k8s_version: k8s_settings["version"],
        k8s_network_pod_cidr: k8s_settings["network"]["pod_cidr"],
        k8s_network_pod_service: k8s_settings["network"]["pod_service"],
        k8s_calico_version: k8s_settings["calico"]["version"],
      }

      if k8s_settings["dashboard"] and k8s_settings["dashboard"]["enable"]
        ansible.extra_vars["k8s_dashboard_enable"] = k8s_settings["dashboard"]["enable"]
      end

      if k8s_settings["dashboard"] and k8s_settings["dashboard"]["version"]
        ansible.extra_vars["k8s_dashboard_version"] = k8s_settings["dashboard"]["version"]
      end
    end

  end

  node_settings = settings["vm"]["cluster"]["node"]

  (1..node_settings["count"]).each do |i|
    config.vm.define "node0#{i}" do |node|
      node.vm.hostname = "node0#{i}"
      node.vm.box = node_settings["box"]

      node.vm.provider "virtualbox" do |vb|
        vb.cpus = node_settings["cpu"]
        vb.memory = node_settings["memory"]
      end

      node.vm.network "private_network", ip: ipBlocks.GetNewIP()
      node.vm.synced_folder "ansible/", "/vagrant/ansible", SharedFoldersEnableSymlinksCreate: false
      node.vm.synced_folder ".tmp/", "/vagrant/tmp", create: true

      node.vm.provision "ansible_local" do |ansible|
        ansible.playbook = "ansible/node.yaml"
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
