
Step 1 - Install Virtualbox
---
![image](https://www.dropbox.com/s/e50moqrl8ev9mrr/virtualbox.png?raw=1)

***VirtualBox is a powerful x86 and AMD64/Intel64 virtualization product for enterprise as well as home use.***

>win, lin, OS X [downloads here](https://www.virtualbox.org)

I don’t think the extension pack is required for what we are doing - The only thing I have found that need that is creating and RDP connection for a windows vm on Virtualbox

>if you do wish to install the extension pack, open up the Virtualbox gui after it installs and go to Preferences | Extensions and link the downloaded extension file

Step 2 - Install Vagrant
---

![image](https://www.dropbox.com/s/bxc533yo8xva2rb/vagrant_logo.png?raw=1)

***Vagrant allows you to create and configure lightweight, reproducible, and portable development environments.***

[Why vagrant?](https://docs.vagrantup.com/v2/why-vagrant/index.html)

>win, lin, OS X [downloads here](https://www.vagrantup.com)

Step 3 Install Git
---
![image](https://www.dropbox.com/s/zyn17c3gh8qfmtj/git.png?raw=1)

***Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.
Git is easy to learn and has a tiny footprint with lightning fast performance. It outclasses SCM tools like Subversion, CVS, Perforce, and ClearCase with features like cheap local branching, convenient staging areas, and multiple workflows.***

>Git may already installed on linux or OS X - if not use ‘apt-get install git’ on .deb type distros (Ubuntu), or ‘yum install git’ for rpm based distros. Check by typing in a terminal window.

>	$ git version


>windows - install git for windows will install git bash [download here](https://git-for-windows.github.io)


Step 4 Install Atom
---
![enter image description here](https://www.dropbox.com/s/ltc7xxhmnccmgvv/atom_logo.png?raw=1)

***Atom is a text editor that's modern, approachable, yet hackable to the core—a tool you can customize to do anything but also use productively without ever touching a config file.. Atom works across operating systems. You can use it on OS X, Windows, or Linux.***

>atom for any platform can be [downloaded here](https://atom.io)



Step 5 - Pull a Vagrant box from the Atlas Repository
---

![image](https://www.dropbox.com/s/ujre8b4n3hdwwgo/HowAtlasWorks.jpg?raw=1)

***Atlas is HashiCorp's commercial offering to bring your Vagrant development environments to production. You can read more about HashiCorp's Atlas and all its features on the Atlas homepage. The Vagrant Push Atlas strategy pushes your application's code to HashiCorp's Atlas service.***

Read more about [Atlas and how it works](http://www.marketwired.com/press-release/hashicorp-launches-atlas-power-devops-application-delivery-on-any-infrastructure-public-1975584.htm).

I have created a vagrant “box” for our use based on CentOS and "push"'d it up to Atlas for general public use and distribution.
>**Note:** If you wish to learn how to create your own vagrant "box" then that is outside the scope of this exercise BUT please let me know and I can walk you through how to build a box and push it up to Atlas or just keep it locally for personal use.

**Proxy Considerations First**
Since we will be using a terminal for most of this exercise (from Git Bash on Windows, or a regular terminal from OS X or Linux) you may need to get through to the Internet using a Proxy Server.  If you are in Atlanta the TP proxy server there is "http://atlproxy.tvlport.com:8080".  If you are in Denver, then the TP proxy server there is "http://proxyden.galileo.corp.lcl:8080". So export that value as an environment variable first, then set the other proxy variables that will be required by various cmd-line tools.


**WIN, LIN, OSX** - For temporarily setting the proxy (on any platform), use this command in a terminal window.

	$ export HTTP_PROXY=<your-proxy-server-url> HTTPS_PROXY=$PROXY http_proxy=$PROXY https_proxy=$PROXY

**WIN, LIN, OSX** - For permanently setting the proxy (on any platform), use this command in a terminal window.

	$ echo -e "export HTTP_PROXY=$HTTP_PROXY\nexport HTTPS_PROXY=$HTTP_PROXY\nexport http_proxy=$HTTP_PROXY\nexport https_proxy=$HTTP_PROXY" >> ~/.bashrc

**WIN** - If you are on windows using git for windows (git bash) I would suggest following these directions

>[Setting Up Github for Windows behind a Proxy Server
What will most probably work…](https://medium.com/neithans-diary/setting-up-github-for-windows-behind-a-proxy-server-1f39b27218b7)

**OS-X, LIN** - If you are on OS-X or Linux then copy that export command into your .bashrc

Now using git bash or an OS X or linux terminal window, you now need to pull this vagrant image I uploaded to the Atlas repository by typing the following vagrant command.

>**Note**: Vagrant can manage many types of boxes, but since these are Virtualbox "boxes" that we will be using these downloaded images will be stored under your home directory  ‘VirtualBox VMs" directory by default,  if you want to change that directory because of space considerations then go to the Virtualbox gui and change it under Preferences | General -> Default Machine Folder


	$ vagrant box add petergdoyle/CentOS-7-x86_64-Minimal-1503-01  


Step 6 - Clone the DockerDemo git Repository
---

With git bash or an OS X or linux terminal window, clone a copy of the “dockerdemo” repository. that will provide us with the Vagrantfile needed to provision a new vm for us to use for the demo.

	$ git clone https://github.com/petergdoyle/dockerdemo

Now open up the Vagrantfile with gui editor - my new favorite is Atom but you can use notepad, write, or vi if you wish.  Since I just cloned the 'dockerdemo' repository,  I can just move into the newly created "dockerdemo' folder and fire up atom with the "dot".

	$ cd dockerdemo
	$ atom .

####Proxies Again, but this time for the new vm

We need to tell the new vm about the proxy settings as well before we create it. So modify the Vagrantfile simply by clicking on the Vagrantfile and then looking for the commented out section that looks like this - and just uncomment out ALL the lines by removing the '#' symbols (but obviously not the first line ```# Global Proxy Settings```)
And replace ```http://myproxy.net:80``` with whichever proxy server url you used for git.
```
# Global Proxy Settings
#  export HTTP_PROXY=http://myproxy.net:80 HTTPS_PROXY=$HTTP_PROXY http_proxy=$HTTP_PROXY https_proxy=$HTTP_PROXY
#  echo "proxy=$HTTP_PROXY" >> /etc/yum.conf
#  cat >/etc/profile.d/proxy.sh <<-EOF
#export HTTP_PROXY=$HTTP_PROXY
#export HTTPS_PROXY=$HTTP_PROXY
#export http_proxy=$HTTP_PROXY
#export https_proxy=$HTTP_PROXY
#EOF
```

There is another section below that needs to be configured as well. Just uncomment those lines the same way (but obviously not the first line ```# NPM Proxy Settings```)

```
# NPM Proxy Settings
#npm config set proxy $HTTP_PROXY
#vnpm config set https-proxy $HTTP_PROXY
```

Okay, now save the file with Atom using a ctl+s key combination or use the file menu and select save. 

###Finally !

Let's bring up the new virtual machine for our development with the vagrant command

	$ vagrant up

You should see a lot of stuff going on there and some type of success message at the end.
Now restart the vm.

	$ vagrant halt; vagrant up

You should now have a running vm that you can ssh into and you should end up inside the new vm terminal as user vagrant on the host 'dockerdemo'

	$ vagrant ssh
    [vagrant@docker ~]$

If everything installed correctly you should be able to verify things. If anything message shows up in red then we will have to figure out what went wrong. 

	$ /vagrant/verify.sh

To check individual items you can run the following

	[vagrant@docker ~]$ docker version
    Client version: 1.7.1
    Client API version: 1.19
    Package Version (client): docker-1.7.1-115.el7.x86_64
    Go version (client): go1.4.2
    Git commit (client): 446ad9b/1.7.1
    OS/Arch (client): linux/amd64
    Server version: 1.7.1
    Server API version: 1.19
    Package Version (server): docker-1.7.1-115.el7.x86_64
    Go version (server): go1.4.2
    Git commit (server): 446ad9b/1.7.1
    OS/Arch (server): linux/amd64

    [vagrant@docker ~]$ docker-compose version
    docker-compose version: 1.4.2
    docker-py version: 1.3.1
    CPython version: 2.7.5
    OpenSSL version: OpenSSL 1.0.1e-fips 11 Feb 2013

	$ [vagrant@docker ~]$ node --version
	v0.10.36

    [vagrant@docker ~]$ mongo --version
	MongoDB shell version: 3.0.6

    [vagrant@docker ~]$ spring version
	Spring CLI v1.2.6.RELEASE

    [vagrant@docker ~]$ java -version
	java version "1.8.0_60"
	Java(TM) SE Runtime Environment (build 1.8.0_60-b27)
	Java HotSpot(TM) 64-Bit Server VM (build 25.60-b23, mixed mode)

	[vagrant@docker ~]$ mvn -version
	Apache Maven 3.3.3 (7994120775791599e205a5524ec3e0dfe41d4a06; 2015-04-22T07:57:37-04:00)
	Maven home: /usr/maven/default
	Java version: 1.8.0_60, vendor: Oracle Corporation
	Java home: /usr/java/jdk1.8.0_60/jre
	Default locale: en_US, platform encoding: UTF-8
	OS name: "linux", version: "3.10.0-229.7.2.el7.x86_64", arch: "amd64", family: "unix"

    [vagrant@docker ~]$ /opt/pivotal/spring-xd/xd/bin/xd-admin

     _____                           __   _______
    /  ___|          (-)             \ \ / /  _  \
    \ `--. _ __  _ __ _ _ __   __ _   \ V /| | | |
     `--. \ '_ \| '__| | '_ \ / _` |  / ^ \| | | |
    /\__/ / |_) | |  | | | | | (_| | / / \ \ |/ /
    \____/| .__/|_|  |_|_| |_|\__, | \/   \/___/
          | |                  __/ |
          |_|                 |___/
    1.1.2.RELEASE                    eXtreme Data


    Started : AdminServerApplication
    Documentation: https://github.com/spring-projects/spring-xd/wiki

    [vagrant@docker ~]$ /usr/storm/default/bin/storm version
	0.9.5

	[vagrant@docker ~]$ redis-cli --version
	redis-cli 2.8.19

	[vagrant@docker ~]$ /usr/hadoop/default/bin/hadoop version
    Hadoop 2.7.1
    Subversion https://git-wip-us.apache.org/repos/asf/hadoop.git -r 15ecc87ccf4a0228f35af08fc56de536e6ce657a
    Compiled by jenkins on 20ß15-06-29T06:04Z
    Compiled with protoc 2.5.0
    From source with checksum fc0a1a23fc1868e4d5ee7fa2b28a58a
    This command was run using /usr/hadoop/hadoop-2.7.1/share/hadoop/common/hadoop-common-2.7.1.jar
