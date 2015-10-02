
Vagrant.configure(2) do |config|

  config.vm.box = "petergdoyle/CentOS-7-x86_64-Minimal-1503-01"

  #allows an ssh connection to be forwarded through the host machine on 2222
  #config.vm.network "forwarded_port", guest: 22, host: 2222, host_ip: "0.0.0.0", id: "ssh", auto_correct: true
  #allows mongo connection to be forwarded through the host machine on 227017

  config.vm.network "forwarded_port", guest: 8000, host: 8000, host_ip: "0.0.0.0", id: "node_port_8000", auto_correct: true

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
    vb.cpus=2 #recommended=4 if available
    vb.memory = "1024" #recommended=3072 or 4096 if available
  end

  config.vm.provision "shell", inline: <<-SHELL

  yum -y update

  #install additional tools
  yum -y install vim htop curl wget net-tools tree

  #install node.js and npm
  yum -y install epel-release gcc gcc-c++
  yum -y install nodejs npm

  #useful node.js packages 
  npm install format-json-stream -g

  #install azure-cli
  npm install azure-cli -g

  #install docker service
  cat >/etc/yum.repos.d/docker.repo <<-EOF
[dockerrepo]
name=Docker Repository
baseurl=https://yum.dockerproject.org/repo/main/centos/7
enabled=1
gpgcheck=1
gpgkey=https://yum.dockerproject.org/gpg
EOF
  yum -y install docker
  systemctl start docker.service
  systemctl enable docker.service

  #allow non-sudo access to run docker commands for user vagrant
  #if you have problems running docker as the vagrant user on the vm (if you 'vagrant ssh'd in
  #after a 'vagrant up'), then
  #restart the host machine and ssh in again to the vm 'vagrant halt; vagrant up; vagrant ssh'
  groupadd docker
  usermod -aG docker vagrant

  #install docker-compose.
  #Compose is a tool for defining and running multi-container applications with Docker.
  yum -y install python-pip
  pip install -U docker-compose


  #set hostname
  hostnamectl set-hostname docker.vbx

  SHELL
end
