
Vagrant.configure(2) do |config|

  config.vm.box = "petergdoyle/CentOS-7-x86_64-Minimal-1503-01"

  #allows an ssh connection to be forwarded through the host machine on 2222
  #config.vm.network "forwarded_port", guest: 22, host: 2222, host_ip: "0.0.0.0", id: "ssh", auto_correct: true
  #allows mongo connection to be forwarded through the host machine on 227017

  #allows an ssh connection to be forwarded through the host machine on 2222
  config.vm.network "forwarded_port", guest: 22, host: 2222, host_ip: "0.0.0.0", id: "ssh", auto_correct: true
  #node proxy
  config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "0.0.0.0", id: "http proxy", auto_correct: true



  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--cpuexecutioncap", "80"]
    vb.cpus=2 #recommended=4 if available
    vb.memory = "1024" #recommended=3072 or 4096 if available
  end

  config.vm.provision "shell", inline: <<-SHELL

  # Global Proxy Settings
#  export HTTP_PROXY=http://myproxy.net:80 HTTPS_PROXY=$HTTP_PROXY http_proxy=$HTTP_PROXY https_proxy=$HTTP_PROXY
#  echo "proxy=$HTTP_PROXY" >> /etc/yum.conf
#  cat >/etc/profile.d/proxy.sh <<-EOF
#export HTTP_PROXY=$HTTP_PROXY
#export HTTPS_PROXY=$HTTP_PROXY
#export http_proxy=$HTTP_PROXY
#export https_proxy=$HTTP_PROXY
#EOF

  if [ -n "$HTTP_PROXY" ]; then
    curl -I -x $HTTP_PROXY http://google.com
    if [ $? -ne 0 ]; then
      echo "invalid proxy settings. cannot continue"
      exit 1
    fi
  fi

  #best to update the os
  yum -y update
  #install additional tools
  eval 'tree' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  yum -y install vim htop curl wget net-tools tree unzip
  fi

  eval 'docker --version' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
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
  else
    echo -e "\e[30;48;5;82m docker already appears to be installed. skipping.\e[0m"
  fi

  eval $'node --version' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  #install node.js and npm
  yum -y install epel-release gcc gcc-c++
  yum -y install nodejs npm

  # NPM Proxy Settings
  #npm config set proxy $HTTP_PROXY
  #vnpm config set https-proxy $HTTP_PROXY
  #useful node.js packages


  npm install format-json-stream -g
  #install azure-cli
  npm install azure-cli -g

  else
    echo -e "\e[30;48;5;82m node, npm, npm-libs already appear to be installed. skipping. \e[0m"
  fi


  cmd='mongo --version'
  eval $cmd > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  #install mongodb and start it and enable it at startup
  cat >/etc/yum.repos.d/mongodb-org-3.repo <<-EOF
[mongodb-org-3.0]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7/mongodb-org/3.0/x86_64/
gpgcheck=0
enabled=1
EOF
  yum -y install mongodb-org mongodb-org-server
  systemctl start mongod.service
  chkconfig mongod on

  else
    echo -e "\e[30;48;5;82m mongo already appears to be installed. skipping. \e[0m"
  fi

  eval 'java -version' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  #install java jdk 8 from oracle
  curl -O -L --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
  "http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jdk-8u60-linux-x64.tar.gz"

  mkdir -p /usr/java; \
    tar -xvf jdk-8u60-linux-x64.tar.gz -C /usr/java; \
    ln -s /usr/java/jdk1.8.0_60/ /usr/java/default; \
    rm -f jdk-8u60-linux-x64.tar.gz

  alternatives --install "/usr/bin/java" "java" "/usr/java/default/bin/java" 99999; \
  alternatives --install "/usr/bin/javac" "javac" "/usr/java/default/bin/javac" 99999; \
  alternatives --install "/usr/bin/javaws" "javaws" "/usr/java/default/bin/javaws" 99999

  export JAVA_HOME=/usr/java/default
  cat >/etc/profile.d/java.sh <<-EOF
export JAVA_HOME=$JAVA_HOME
EOF

  else
    echo -e "\e[30;48;5;82m java already appears to be installed. skipping. \e[0m"
  fi

  eval 'mvn -version' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  #install maven
  curl -O http://www.eu.apache.org/dist/maven/maven-3/3.3.3/binaries/apache-maven-3.3.3-bin.tar.gz
  mkdir /usr/maven; \
  tar -xvf apache-maven-3.3.3-bin.tar.gz -C /usr/maven; \
  ln -s /usr/maven/apache-maven-3.3.3 /usr/maven/default; \
  rm -f apache-maven-3.3.3-bin.tar.gz

  alternatives --install "/usr/bin/mvn" "mvn" "/usr/maven/default/bin/mvn" 99999

  export MAVEN_HOME=/usr/maven/default
  cat >/etc/profile.d/maven.sh <<-EOF
export MAVEN_HOME=$MAVEN_HOME
EOF

  else
    echo -e "\e[30;48;5;82m maven already appears to be installed. skipping. \e[0m"
  fi


  eval '/usr/kafka/default/bin/kafka-run-class.sh' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  #install apache kafka
  curl -O --insecure http://apache.claz.org/kafka/0.8.2.1/kafka_2.9.1-0.8.2.1.tgz
  mkdir /usr/kafka; \
  tar -xvf kafka_2.9.1-0.8.2.1.tgz -C /usr/kafka; \
  ln -s /usr/kafka/kafka_2.9.1-0.8.2.1 /usr/kafka/default; \
  rm -f kafka_2.9.1-0.8.2.1.tgz
  export KAFKA_HOME='/usr/kafka/default'
  cat >/etc/profile.d/kafka.sh <<-EOF
export KAFKA_HOME=$KAFKA_HOME
export PATH=$PATH:$KAFKA_HOME/bin
EOF

  else
    echo -e "\e[30;48;5;82m kafak already appears to be installed. skipping. \e[0m"
  fi


  eval '/usr/storm/default/bin/storm version' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  #install apache storm
  curl -O http://apache.arvixe.com/storm/apache-storm-0.9.5/apache-storm-0.9.5.tar.gz
  mkdir /usr/storm; \
  tar -xvf apache-storm-0.9.5.tar.gz -C /usr/storm; \
  ln -s /usr/storm/apache-storm-0.9.5 /usr/storm/default; \
  rm -f apache-storm-0.9.5.tar.gz
  export STORM_HOME='/usr/storm/default'
  cat >/etc/profile.d/storm.sh <<-EOF
export STORM_HOME=$STORM_HOME
export PATH=$PATH:$STORM_HOME/bin
EOF

  else
    echo -e "\e[30;48;5;82m storm already appears to be installed. skipping. \e[0m"
  fi


  eval '/usr/hadoop/default/bin/hadoop version' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  #install ahapch hadoop
  curl -O http://apache.arvixe.com/hadoop/common/stable/hadoop-2.7.1.tar.gz
  curl -O https://dist.apache.org/repos/dist/release/hadoop/common/hadoop-2.7.1/hadoop-2.7.1-src.tar.gz.asc
  curl -O https://dist.apache.org/repos/dist/release/hadoop/common/KEYS
  gpg --import KEYS
  gpg --verify hadoop-2.7.1-src.tar.gz.asc
  mkdir /usr/hadoop; \
  tar -xvf hadoop-2.7.1.tar.gz -C /usr/hadoop; \
  ln -s /usr/hadoop/hadoop-2.7.1 /usr/hadoop/default
  rm -fr hadoop-2.7.1.tar.gz hadoop-2.7.1.tar.gz.asc
  export HADOOP_HOME='/usr/hadoop/default'
  cat >/etc/profile.d/hadoop.sh <<-EOF
export HADOOP_HOME=$HADOOP_HOME
export PATH=$PATH:$HADOOP_HOME/bin
EOF

  else
    echo -e "\e[30;48;5;82m hadoop already appears to be installed. skipping. \e[0m"
  fi

  eval '/opt/pivotal/spring-xd/xd/bin/xd-admin' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  #install spring xd
  wget https://repo.spring.io/libs-release-local/org/springframework/xd/spring-xd/1.1.2.RELEASE/spring-xd-1.1.2.RELEASE-1.noarch.rpm
  yum -y localinstall spring-xd-1.1.2.RELEASE-1.noarch.rpm
  alternatives --install /usr/bin/xd-admin xd-admin /opt/pivotal/spring-xd/xd/bin/xd-admin 99999
  alternatives --install /usr/bin/xd-container xd-container /opt/pivotal/spring-xd/xd/bin/xd-container 99999
  alternatives --install /usr/bin/xd-singlenode xd-singlenode /opt/pivotal/spring-xd/xd/bin/xd-singlenode 99999
  sed -i "/#Port that admin-ui is listening on/a xd:\\n  ui:\\n    allow_origin: \"*\"" /opt/pivotal/spring-xd/xd/config/servers.yml
  rm -f spring-xd-1.1.2.RELEASE-1.noarch.rpm
  else
    echo -e "\e[30;48;5;82m spring-xd already appears to be installed. skipping. \e[0m"
  fi

  eval "su - vagrant -c 'spring version'" > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  #install spring boot
  su - vagrant -c 'curl -s get.gvmtool.net | bash'
  su - vagrant -c 'printf "sdkman_auto_answer=true" > /home/vagrant/.sdkman/etc/config'
  su - vagrant -c 'sdk install springboot'
  #su - vagrant -c 'sdk install groovy'     #optional
  #su - vagrant -c 'sdk install grails'     #optional
  else
    echo -e "\e[30;48;5;82m springboot already appears to be installed. skipping. \e[0m"
  fi

  eval 'redis-cli --version' > /dev/null 2>&1
  if [ $? -eq 127 ]; then
  #install redis
  yum -y install redis redis-cli
  systemctl start redis.service
  systemctl enable redis.service
  else
    echo -e "\e[30;48;5;82m redis already appears to be installed. skipping. \e[0m"
  fi

  #set hostname
  hostnamectl set-hostname dockerdemo.vbx

  SHELL
end
