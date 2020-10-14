require 'yaml'

# Load the external YAML configuration from either a custom config.yaml file or
# the default file, config-default.yaml.
#params = YAML.load_file(File.file?('config.yaml') ? 'config.yaml' : 'config-default.yaml')['vagrant']

Vagrant.configure(2) do |config|

# OS check
module OS
    def OS.windows?
        (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    end
    def OS.mac?
        (/darwin/ =~ RUBY_PLATFORM) != nil
    end
    def OS.unix?
        !OS.windows?
    end
    def OS.linux?
        OS.unix? and not OS.mac?
    end
end

# Get network
module Network
    # Detect OS
    if OS.windows?
        netAdapters = `"C:/Program Files/Oracle/VirtualBox/VBoxManage.exe" list hostonlyifs`.split(/[\n,:]/).collect(&:strip).grep(/^VirtualBox/)
    elsif (OS.mac? || OS.unix?)
        netAdapters = `VBoxManage list hostonlyifs`.split(/[\n,:," "]/).grep(/^vboxnet/)
    else
        puts "Unknown host OS detected"
    end

    # Set expected network adapters' names
    numAdapters = netAdapters.size
    (1..numAdapters).each do |i|
        index_val = netAdapters[i-1]
        instance_variable_set("@adapter#{i}", index_val)
        attr_accessor :"adapter#{i}"
    end

    # Global number of adapters
    attr_accessor :vnet_number
    @vnet_number = numAdapters
end

# Default value is 300 seconds
config.vm.boot_timeout = 600
include Network

# Define "Ubuntu" box path
config.vm.define vm_name = "UbuntuVM", autostart: false do |ubuntu|
    ubuntu.trigger.before [:up] do |trigger|
      if Vagrant.has_plugin?("vagrant-vbguest")
        ons.vbguest.auto_update = false
      end
    end

    # Vagrant box name
    ubuntu.vm.box = "file://builds/virtualbox-ubuntu2004-server.box"
    ubuntu.vm.guest = :linux

    if Network.vnet_number < 1
        abort("This VM requires 1 virtual network adapter. But only #{Network.vnet_number} found. Please reconfigure VirtualBox.")
    end

    # Network configurations
    ubuntu.vm.network :forwarded_port, adapter: 1, guest: 22, host: 2226, host_ip: "127.0.0.1", auto_correct: true, id: "ssh"
    ubuntu.ssh.username = "vagrant"
    ubuntu.ssh.password = "vagrant"
    ubuntu.ssh.insert_key = false

    # Provider
    ubuntu.vm.provider "virtualbox" do |vb|
        vb.name = "DevopsVM"
        vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
        vb.customize ["modifyvm", :id, "--accelerate3d", "on"]
        vb.customize ["modifyvm", :id, "--nic1", "nat"]
        vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
        vb.gui = true
    end

    # Gitlab private key
    gitlab_key = "id_ed25519"
    ubuntu.vm.provision "file", source: "~/.ssh/#{gitlab_key}", destination: "/home/vagrant/.ssh/#{gitlab_key}"
    $set_permission = <<-SCRIPT
    if [[ -f /home/vagrant/.ssh/#{gitlab_key} ]]; then
        chmod 400 /home/vagrant/.ssh/#{gitlab_key}
    fi
    SCRIPT
    ubuntu.vm.provision "shell",
        inline: $set_permission
    
    # Shared Folder
    ubuntu.vm.synced_folder ".", "/vagrant", disabled: true
end
end
