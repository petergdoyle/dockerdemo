# dockerdemo


It might be helpful to read the associated document [Docker Getting Started](DOCKER_GETTING_STARTED.md) before running through this.

__Step 1: Set up a Mongodb Container__
--
Dockerfile for the mongo image
```javascript
FROM centos:latest
MAINTAINER Peter Doyle "peter.g.doyle@*.com"
ENV REFRESHED_AT 2015-09-01

COPY mongodb-org-3.0.repo /etc/yum.repos.d/mongodb-org-3.0.repo

RUN yum -y update
RUN yum -y install mongodb-org
RUN /usr/bin/systemctl disable mongod.service
RUN mkdir -p /data/db

ENTRYPOINT ["/usr/bin/mongod"]

CMD []

EXPOSE 27017
```

```console
$ pwd=$pwd
$ git clone https://github.com/petergdoyle/dockerdemo.git
$ cd $pwd/dockerdemo/fullstack/mongo
$ docker build --no-cache -t demo/fullstack_mongo_db .
```

check images
```console
$ docker images
```

You should now see the image (along with any others that you have created) to ensure that there were no errors and the image got successfully defined. If it didn't build properly, the petergdoyle/fullstack_mongo_db label won't be there and you will have to do a docker rmi command with the ImageID that got created and fix the errors and start again - there is not fail-on-error directive to not create the image
```console
$ docker images
REPOSITORY                       TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
demo/fullstack_mongo_db   latest              3c76da53d163        2 hours ago         455.1 MB

```

Now, create the container using the image. Notice that i can pass in the startup parameters because of how the Dockerfile ENTRYPOINT was set up (without parameters) but then picking up the parameters as command parameters to the mongod executable. Again mongod must be run in the foreground rather than set up as a service or daemon.
```console
$ docker run -p 27017:27017 --name mongo_instance_001 -h mongo001.dkr -d demo/fullstack_mongo_db --smallfiles
```

Now check the container to see it is up and available (it is running if all goes well)
```console
$ docker ps -l
CONTAINER ID        IMAGE                            COMMAND                CREATED             STATUS              PORTS                      NAMES
f19e0c9e7e6e        demo/fullstack_mongo_db   "/usr/bin/mongod --n   9 minutes ago       Up 3 minutes        0.0.0.0:27017->27017/tcp   mongo_instance_001
```

Connect to the running container. In the container, connect to the running mongod using mongo

```console
$ docker exec -i -t mongo_instance_001 bash
[root@mongo001 /]# mongo
MongoDB shell version: 3.0.6
connecting to: test
Welcome to the MongoDB shell.
For interactive help, type "help".
For more comprehensive documentation, see
	http://docs.mongodb.org/
Questions? Try the support group
	http://groups.google.com/group/mongodb-user
Server has startup warnings:
2015-09-07T15:23:40.634+0000 I CONTROL  [initandlisten] ** WARNING: You are running this process as the root user, which is not recommended.
2015-09-07T15:23:40.634+0000 I CONTROL  [initandlisten]
2015-09-07T15:23:40.634+0000 I CONTROL  [initandlisten]
2015-09-07T15:23:40.634+0000 I CONTROL  [initandlisten] ** WARNING: /sys/kernel/mm/transparent_hugepage/enabled is 'always'.
2015-09-07T15:23:40.634+0000 I CONTROL  [initandlisten] **        We suggest setting it to 'never'
2015-09-07T15:23:40.634+0000 I CONTROL  [initandlisten]
2015-09-07T15:23:40.634+0000 I CONTROL  [initandlisten] ** WARNING: /sys/kernel/mm/transparent_hugepage/defrag is 'always'.
2015-09-07T15:23:40.634+0000 I CONTROL  [initandlisten] **        We suggest setting it to 'never'
2015-09-07T15:23:40.634+0000 I CONTROL  [initandlisten]
>
```

You should now be able to check the mongod service by running a telnet command. CTL-Z, CTL-Z to exit telnet.
```console
$ telnet localhost 27017
Trying ::1...
Connected to localhost.
Escape character is '^]'.

```

And now stop the container
```console
$ docker stop mongo_instance_001
 mongo_instance_001
```

And telnet should fail
```console
$ telnet localhost 27017
Trying ::1...
telnet: connect to address ::1: Connection refused
Trying 127.0.0.1...
telnet: connect to address 127.0.0.1: Connection refused
```

And now start the container up again
```console
$ docker start mongo_instance_001
 mongo_instance_001
```

__Step 2: Set up a Node.js Container__
--
Dockerfile for the node image. Notice that I am using an official image from Node.js rather than building up one of my own. I am opening up port 8888 so I can communicate with an HTTP server running on node if I set one up.
```javascript
FROM node:0.10-onbuild

EXPOSE 8888
```

So go in to the node directory of the cloned git location ($pwd was set previously to be the folder where the repo was cloned). Now we need to install the necessary node libraries. Remember this is all done host-side for this demo. *Note* those dependencies are defined in package.json if you are unfamiliar with node dependencies.
```console
$ cd $pwd/dockerdemo/fullstack/node
$ npm install
```
Now build the docker node image
```console
docker build --no-cache -t demo/fullstack_node:latest .
```

Now create and run the node image and execute the simple node.js script. It should run the console statement in the say_hello.js file.
```javascript
console.log("hello from node.js");
```
```console
$ docker run -it --name say_hello demo/fullstack_node node say_hello.js
hello from node.js
```

Now lets run the node script to that uses the mongod driver from node and attempts to ping the mongo instance we know is running on localhst:27017.
```javascript
var MongoClient = require('mongodb').MongoClient;
var assert = require('assert');

var url = 'mongodb://localhost:27017/test';
MongoClient.connect(url, function(err, db) {
  assert.equal(null, err);
  console.log("Connected correctly to server.");
  db.close();
});

```

But now we get an error. The mongodb driver cannot connect.
```console
$ docker run -it --name say_hello_mongo demo/fullstack_node node say_hello.js

/usr/src/app/node_modules/mongodb/lib/server.js:228
        process.nextTick(function() { throw err; })
                                            ^
AssertionError: null == {"name":"MongoError","message":"connect ECONNREFUSED"}
    at /usr/src/app/say_hello_mongo.js:6:10
    at /usr/src/app/node_modules/mongodb/lib/mongo_client.js:267:20
    at /usr/src/app/node_modules/mongodb/lib/db.js:218:14
    at null.<anonymous> (/usr/src/app/node_modules/mongodb/lib/server.js:226:9)
    at g (events.js:180:16)
    at emit (events.js:98:17)
    at null.<anonymous> (/usr/src/app/node_modules/mongodb/node_modules/mongodb-core/lib/topologies/server.js:263:68)
    at g (events.js:180:16)
    at emit (events.js:98:17)
    at null.<anonymous> (/usr/src/app/node_modules/mongodb/node_modules/mongodb-core/lib/connection/pool.js:77:12)

```

Docker has assigned an IP number to the mongo_instance_001. We can see that by inspecting the running container. But this is random and the program would have to be modified all the time
```console
$ docker inspect -f '{{.NetworkSettings.IPAddress}}' mongo_instance_001
172.17.0.77
```
There is a better way using the --link directive. This applies an alias a docker container and give that reference to the *linked* container
```console
$ docker run -it --name say_hello_mongo_2 --link mongo_instance_001:mongo001 demo/fullstack_node bash
```
In fact, if you go into the ```/etc/hosts``` file for that container (say_hello_mongo_3), then you would see docker has added the host entry for the mongo001 instance.
```console
root@91b5da9e09c1:/usr/src/app# more /etc/hosts
172.17.0.98	91b5da9e09c1
127.0.0.1	localhost
::1	localhost ip6-localhost ip6-loopback
fe00::0	ip6-localnet
ff00::0	ip6-mcastprefix
ff02::1	ip6-allnodes
ff02::2	ip6-allrouters
172.17.0.77	mongo001 mongo001 mongo_instance_001

```
Now the program source needs to be modified to indicate the correct mongodb
```javascript
var MongoClient = require('mongodb').MongoClient;
var assert = require('assert');

var url = 'mongodb://mongo_instance_001:27017/test';
MongoClient.connect(url, function(err, db) {
  assert.equal(null, err);
  console.log("Connected correctly to server.");
  db.close();
});
```
Notice that I created a new container using the bash directive to get it running since execution of the node command previously failed. So lets test things out while this container is still running. Notice that this container is based on the official node.js image so that ends up making a copy of contents of the source directory where we build the image. So really I should have included a .dockerignore file there to exclude anything I didn't want copied to the container. **GOTCHA** that also implies that changes to the source files are not affected unless I was to build another image and copy the modifications. This is much different that using the shared volume -v directive. It also provides a WORKINGDIR directive to the container so that execution of the node programs is done in the default directory where the source files are copied to. That is why 'node say_hello_mongo.js' works as a command from the run statement.
```javascript
root@91b5da9e09c1:/usr/src/app# ls -al
total 28
drwxr-xr-x. 3 root root 4096 Sep  7 20:49 .
drwxr-xr-x. 3 root root 4096 Aug 28 19:51 ..
-rw-rw-r--. 1 root root   36 Sep  7 14:51 Dockerfile
drwxrwxr-x. 4 root root 4096 Sep  7 14:55 node_modules
-rw-rw-r--. 1 root root  309 Sep  7 14:57 package.json
-rw-rw-r--. 1 root root   37 Sep  7 15:03 say_hello.js
-rw-rw-r--. 1 root root  265 Sep  7 20:14 say_hello_mongo.js
```
So now we can run the node program like we were trying to from the first container, which in this case is a simple start to end script but usually might be a web server using  node and express.
```javascript
root@93bb70e6bae9:/usr/src/app# node say_hello_mongo.js
Connected correctly to server.
```
So lets clean up the containers we don't need, one the first one that failed to run and now the one we used to get into it with a bash say_hello. And we should still have the mongo_instance_001 up and running after that.
```console
$ docker rm say_hello_mongo say_hello_mongo_2
$ docker ps -a
CONTAINER ID        IMAGE                          COMMAND                CREATED             STATUS                      PORTS                              NAMES
2b4dc075f503        demo/fullstack_mongo_db        "/usr/bin/mongod --s   32 minutes ago      Up 32 minutes               0.0.0.0:27017->27017/tcp           mongo_instance_001   

```
And we should be able to connect to mongo and run the node script and we should see the same success message.
```console
$ docker run -it --name say_hello_mongo --link mongo_instance_001:mongo001 demo/fullstack_node node say_hello_mongo.js
Connected correctly to server.
```

You can link multiple containers together. For example, if we wanted to use our mongo instance for multiple web applications, we could link each web application container to the same mongo container using the same --link directive.
