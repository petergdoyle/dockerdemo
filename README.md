# dockerdemo


check images
```console
$ docker images
```
check containers
```console
$ docker ps -l
```

Create the new image the image from the Dockerfile in the fullstack/mongo folder
```javascript
FROM centos:latest
MAINTAINER Peter Doyle "peter.g.doyle@gmail.com"
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
$ git clone https://github.com/petergdoyle/dockerdemo.git
$ cd dockerdemo/fullstack/mongo
$ docker build --no-cache -t demo/fullstack_mongo_db .
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
