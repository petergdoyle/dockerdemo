var MongoClient = require('mongodb').MongoClient;
var assert = require('assert');

var url = 'mongodb://mongo001:27017/test';
MongoClient.connect(url, function(err, db) {
  assert.equal(null, err);
  console.log("Connected correctly to ",url);
  db.close();
});
