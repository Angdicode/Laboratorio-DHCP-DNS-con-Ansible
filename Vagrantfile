Vagrant.configure("2") do |config|
  config.vm.box = "generic/rocky9"
  config.vm.synced_folder ".", "/vagrant"

  config.vm.define "ansible" do |node|
    node.vm.hostname = "ansible.lab.example.internal"
    node.vm.network "private_network", ip: "192.168.56.10"

    node.vm.provider "virtualbox" do |vb|
      vb.name = "ansible-controller"
      vb.memory = 1024
      vb.cpus = 2
    end

    node.vm.provision "shell", inline: <<-SHELL
      dnf install -y ansible-core git python3 python3-libselinux
    SHELL
  end

  config.vm.define "server" do |node|
    node.vm.hostname = "server.lab.example.internal"
    node.vm.network "private_network", ip: "192.168.56.20"
    node.vm.network "private_network", ip: "192.168.50.10", virtualbox__intnet: "dhcp-lab"

    node.vm.provider "virtualbox" do |vb|
      vb.name = "dns-dhcp-server"
      vb.memory = 1536
      vb.cpus = 2
    end
  end

  config.vm.define "client" do |node|
    node.vm.hostname = "client.lab.example.internal"
    node.vm.network "private_network", ip: "192.168.56.30"
    node.vm.network "private_network", auto_config: false, virtualbox__intnet: "dhcp-lab"

    node.vm.provider "virtualbox" do |vb|
      vb.name = "lab-client"
      vb.memory = 1024
      vb.cpus = 1
    end
  end
end
