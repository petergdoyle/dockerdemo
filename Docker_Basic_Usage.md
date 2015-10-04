

![image](https://www.dropbox.com/s/a4l0q0zvt3y92rp/dockerize-php-application-300x250.jpg?raw=1)

##Docker Basic Usage


The official Docker Command Line reference is located [here](https://docs.docker.com/reference/commandline/search/). This is just a quick reference covering the most common docker commands for our needs. 


Make sure Docker is installed and you have permissions set to run it

	$ docker --version

###Image related Commands

List Docker Images on your local machine

	$ docker images

Search the Docker Hub for images (example. centos)

	$ docker search centos

Push an image to Docker Hub (requires a Docker Hub account)

	$ docker push <userid>/<image-name>

Pull a Docker image to your local repository

	$ docker pull <image-name>

Remove an image from the local repository

	$ docker rmi <image-name>

###Container related Commands

List all Containers on your local machine

	$ docker ps -a 

Build a Container from a directory with a Dockerfile in it

	$ docker build =t="<namespace>/<image-name>" . 

Start a stopped Container

	$ docker start <container-name>

Stop a running Container

	$ docker stop <container-name>

Create and run a container (simple example). Note this container will stop once the command specified exits. If you specify "bash" as the command then you will get a terminal session. Once you exit that terminal, the container stops running. If you were to specify another command like 'java -version' that will be executed and then the container will stop. **Containers only keep running while there is something to do.**

	$ docker run -t -i <namespace>/<image-name> <cmd>

Create and run the container and remove it when it is done running>. This means the Container is one-time use and will not be saved to restart again. 

	$ docker run --rm -t -i <namespace>/<image-name> <cmd>

Create amd run the container as a daemon (keeps running)

	$ docker run -d <namespace>/<image-name> <cmd>

Create amd run the container as a daemon and specify the name of the Container rather than having it assigned a random name. 

	$ docker run -d --name <container-name> <namespace>/<image-name> <cmd>

Create amd run the container as a daemon and specify a hostname (keeps you sane when you are connected). Recommendation is to name it closely to the container name. In this example if the container name is mongo_instance_0, then name the host (the one you will see if you open up a terminal session to it) the same. 

	$ docker run -d -h mongo_instance_0.dkr --name mongo_instance_0 <namespace>/<image-name> <cmd>

Create a new Container that is linked to another one (by network ip)

	$ docker run -d -t -i -h node_js_api_server.dkr --link mongo_instance_0:mongo_instance_0  --name node_js_api_server <namespace>/<image-name> <cmd> 


Start a terminal session with a running Container

	$ docker exec -t -i <container-name> bash 

View Container log. Because Docker Container command HAVE TO run in the foreground, that means that console output is available as a sort of logging facility. 

	$ docker logs <container-name>
    
Tail the log. The docker logs command batch-retrieves logs present at the time of execution.
The docker logs --follow command will continue streaming the new output from the container’s STDOUT and STDERR.

	$ docker logs -f <container-name>
    
Display the running processes of a container. 

	$ docker top <container-name>
    
Sharing folders/volumes between host and container. In this example the host directory has nodejs source folder named "node" and this will be available to the container under a /node mount. 

	$ docker run --rm -t -i --name="shared_volume_test" -v $PWD/node:/node centos:latest /bin/bash
    
Sharing folders/volumes between running containers. 