

mkdir node
cd node
npm init

docker build --no-cache -t petergdoyle/fullstack_node:latest .

npm install mongod assert --save
docker run -it --name say_hello_mongo petergdoyle/fullstack_node node say_hello_mongo.js
