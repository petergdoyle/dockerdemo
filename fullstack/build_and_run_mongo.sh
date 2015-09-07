

# check images
[peter@engine1 mongo]$ docker images
# check containers
[peter@engine1 mongo]$ docker ps -l

# create the new image the image from
[peter@engine1 mongo]$ docker build --no-cache -t petergdoyle/fullstack_mongo_db .

# check images again to see that there were no errors and the image got succesfully defined
# if it didn't the petergdoyle/fullstack_mongo_db label won't be there
# and you will have to do a docker rmi command with the ImageID that got created and
# fix the errors and start again - there is not fail-on-error directive to not create the image

# check images again and make sure you see the one with the refid used
[peter@engine1 mongo]$ docker images

# create the container using the image
# notice that i can pass in the startup parameters
[peter@engine1 mongo]$ docker run -p 27017:27017 --name mongo_instance_001 -h mongo001.dkr -d petergdoyle/fullstack_mongo_db --smallfiles

# check containers
[peter@engine1 mongo]$ docker ps -l
ONTAINER ID        IMAGE                            COMMAND                CREATED             STATUS              PORTS                      NAMES
f19e0c9e7e6e        petergdoyle/fullstack_mongo_db   "/usr/bin/mongod --n   9 minutes ago       Up 3 minutes        0.0.0.0:27017->27017/tcp   mongo_instance_001


#connect to the running container
#in the container, connect to the running mongod using mongo
[peter@engine1 mongo]$ docker exec -i -t mongo_instance_001 bash

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
