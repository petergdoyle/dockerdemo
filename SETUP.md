
Step 1 - Install Virtualbox
---
![image](https://www.virtualbox.org/graphics/vbox_logo2_gradient.png)
***VirtualBox is a powerful x86 and AMD64/Intel64 virtualization product for enterprise as well as home use.***

>win, lin, OS X [downloads here](https://www.virtualbox.org)

I don’t think the extension pack is required for what we are doing - The only thing I have found that need that is creating and RDP connection for a windows vm on Virtualbox

* if you do wish to install the extension pack, open up the Virtualbox gui after it installs and go to Preferences | Extensions and link the downloaded extension file

Step 2 - Install Vagrant
---

![image](https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Vagrant.png/300px-Vagrant.png)

***Vagrant allows you to create and configure lightweight, reproducible, and portable development environments.***

[Why vagrant?](https://docs.vagrantup.com/v2/why-vagrant/index.html)

>win, lin, OS X [downloads here](https://www.vagrantup.com)

Step 3 Install Git
---
![image](https://git-for-windows.github.io/img/git_logo.png)

>should be already installed on linux or OS X - if not use ‘apt-get install git’ on .deb type distros (Ubuntu), or ‘yum install git’ for rpm based distros

>windows - install git for windows will install git bash [download here](https://git-for-windows.github.io)


Step 4 Install Atom
---
![enter image description here](http://4.bp.blogspot.com/-V3vQXRn-OXs/VY_JH119nNI/AAAAAAAAXPE/XxjFVT8skck/s200/atom-icon.png "image")

***Atom is a text editor that's modern, approachable, yet hackable to the core—a tool you can customize to do anything but also use productively without ever touching a config file.. Atom works across operating systems. You can use it on OS X, Windows, or Linux.***

>atom for any platform can be [downloaded here](https://atom.io)



Step 5 - Pull a Vagrant box from the Atlas Repository
---
***Atlas is HashiCorp's commercial offering to bring your Vagrant development environments to production. You can read more about HashiCorp's Atlas and all its features on the Atlas homepage. The Vagrant Push Atlas strategy pushes your application's code to HashiCorp's Atlas service.***

I have created a vagrant “box” for our use based on CentOS and "push"'d it up to Atlas for general public use and distribution.
**Note:** If you wish to learn how to create your own vagrant "box" then that is outside the scope of this exercise BUT please let me know and I can walk you through how to build a box and push it up to Atlas or just keep it locally for personal use.

**Proxy Considerations First**
Since we will be using a terminal for most of this exercise (from Git Bash on Windows, or a regular terminal from OS X or Linux) you may need to get through to the Internet using a Proxy Server.  If you are in Atlanta the TP proxy server there is "http://atlproxy.tvlport.com:8080".  If you are in Denver, then the TP proxy server there is "http://proxyden.galileo.corp.lcl:8080". So export that value as an environment variable first, then set the other proxy variables that will be required by various cmd-line tools.

	$ export PROXY='<your-proxy-server-url>' HTTP_PROXY=$PROXY HTTPS_PROXY=$PROXY http_proxy=$PROXY https_proxy=$PROXY


Now using git bash or an OS X or linux terminal window, you now need to pull this vagrant image I uploaded to the Atlas repository by typing the following vagrant command.

**Note**: Vagrant can manage many types of boxes, but since these are Virtualbox "boxes" that we will be using these downloaded images will be stored under your home directory  ‘VirtualBox VMs" directory by default,  if you want to change that directory because of space considerations then go to the Virtualbox gui and change it under Preferences | General -> Default Machine Folder


	$ vagrant box add petergdoyle/CentOS-7-x86_64-Minimal-1503-01  


Step 6 - Clone the DockerDemo git Repository
--

With git bash or an OS X or linux terminal window, clone a copy of the “dockerdemo” repository. that will provide us with the Vagrantfile needed to provision a new vm for us to use for the demo.

	$ git clone https://github.com/petergdoyle/dockerdemo

Now open up the Vagrantfile with gui editor - my new favorite is Atom but you can use notepad, write, or vi if you wish.  Since I just cloned the 'dockerdemo' repository,  I can just move into the newly created "dockerdemo' folder and fire up atom with the "dot".

	$ cd dockerdemo
	$ atom .

Now modify the Vagrantfile simply by ...
