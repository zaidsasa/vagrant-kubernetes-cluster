require "yaml"
vagrant_root = File.dirname(File.expand_path(__FILE__))
settings = YAML.load_file "#{vagrant_root}/settings.yaml"

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
      end

    end



  end

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Disable the default share of the current code directory. Doing this
  # provides improved isolation between the vagrant box and your host
  # by making sure your Vagrantfile isn't accessible to the vagrant box.
  # If you use this you may want to enable additional shared subfolders as
  # shown above.
  # config.vm.synced_folder ".", "/vagrant", disabled: true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Ansible, Chef, Docker, Puppet and Salt are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
