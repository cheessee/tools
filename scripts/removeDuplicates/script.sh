#!/bin/bash

# Load configuration file
source config.properties

echo "var mongo = connect(\"platformadmin:0pen-platf0rm-2018!@localhost:27017/admin\");

var db = mongo.getSiblingDB('onesaitplatform_rtdb');


db.$ontologia.aggregate([{\$group:{_id:\"\$$ontologia.$clave\", $ontologia:{\$push:\"\$_id\"}, count: {\$sum: 1}}},
{\$match:{count: {\$gt: 1}}}
]).forEach(function(doc){
  doc.$ontologia.shift();
  db.$ontologia.remove({_id : {\$in: doc.$ontologia}});
});
" > javascript.js

mongo -u platformadmin -p 0pen-platf0rm-2018! --authenticationDatabase admin javascript.js
