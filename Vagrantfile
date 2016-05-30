# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

   config.vm.network "forwarded_port", guest: 5432, host: 5432
   config.vm.network "forwarded_port", guest: 8081, host: 8081
   config.vm.network "forwarded_port", guest: 8888, host: 8888
   config.vm.network "forwarded_port", guest: 9999, host: 9999

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "phusion/ubuntu-14.04-amd64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

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

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
     vb.memory = "2048"
   end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "vanessa-dockers/pgsteroids"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   sudo apt-get update
  #   sudo apt-get install -y apache2
  # SHELL

  # Only run the provisioning on the first 'vagrant up'
  if Dir.glob("#{File.dirname(__FILE__)}/.vagrant/machines/default/*/id").empty?
    # Install Docker
    pkg_cmd = "curl -sSL https://get.docker.com/ | sh; "
    # Add vagrant user to the docker group
    pkg_cmd << "usermod -a -G docker vagrant; "
    pkg_cmd << "apt-get install zfs-fuse -y -q;"
    config.vm.provision :shell, :inline => pkg_cmd

    config.vm.provider "virtualbox" do | v |

      # 0 port is for sytem disk
      file_to_disk1 = './.vagrant/zfs/large_disk1.vdi'
      file_to_disk2 = './.vagrant/zfs/large_disk2.vdi'
      file_to_disk3 = './.vagrant/zfs/large_disk3.vdi'

      unless File.exist?(file_to_disk1) # if there is a one there is a 3 (TODO)
        v.customize ['createhd', '--filename', file_to_disk1, '--size', 250 * 1024]
        v.customize ['createhd', '--filename', file_to_disk2, '--size', 250 * 1024]
        v.customize ['createhd', '--filename', file_to_disk3, '--size', 250 * 1024]
      end
      v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk1]
      v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', file_to_disk2]
      v.customize ['storageattach', :id, '--storagectl', 'SATA Controller', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', file_to_disk3]

      #apply temp_tablespace to separate dev
      file_to_disk4 = './.vagrant/zfs/large_disk4.vdi'
      unless File.exist?(file_to_disk4)
        v.customize ['createhd', '--filename', file_to_disk4, '--size', 250 * 1024]
      end
    end

    # copy paste - because we need to explane 3 different port devices
    pkg_cmd = "zpool create lldata1 -m /srv/main /dev/sdb; "
    pkg_cmd << "zfs set compression=gzip-9 lldata1; "
    pkg_cmd << "zfs set recordsize=8k lldata1; "
    pkg_cmd << "zfs set atime=off lldata1; "
    pkg_cmd << "zpool create lldata2 -m /srv/second /dev/sdc; "
    pkg_cmd << "zfs set compression=gzip-9 lldata2; "
    pkg_cmd << "zfs set recordsize=8k lldata2; "
    pkg_cmd << "zfs set atime=off lldata2; "
    pkg_cmd << "zpool create lldata3 -m /srv/extension /dev/sdd; "
    pkg_cmd << "zfs set compression=gzip-9 lldata3; "
    pkg_cmd << "zfs set recordsize=8k lldata3; "
    pkg_cmd << "zfs set atime=off lldata3; "
    
    #temptablespace (rigth now with )
    pkg_cmd << "zpool create lldata4 -m /srv/four /dev/sde; "
    pkg_cmd << "zfs set compression=gzip-9 lldata4; "

    
    config.vm.provision :shell, :inline => pkg_cmd

    #mkfs.ext4 -E stripe-wigth=256 (noatime, discard, defaults, nobarrier)
    #mkfs.btrfs -l 8192 compress=lzo (noatime, discard, defaults, nobarrier, ssd)
    
  end
  pkg_cmd = "apt-get install dnsmasq python3-pip python-psycopg2 libdbd-pg-perl libdbi-perl -y -q; "
  config.vm.provision :shell, :inline => pkg_cmd

end
