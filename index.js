// Importing the module
var socketNER = require("ner-node")
var express = require('express');
var bodyParser = require('body-parser');
var app = express();
app.use(bodyParser.json()); // for parsing application/json

var NER = socketNER(1234, 'classifiers/english.muc.7class.distsim.crf.ser.gz', "./stanford-ner-2015-04-20/")
NER.init()
console.log('NER intialized')

app.get('/restart', function(req, res) {
  try{
    NER.init()
    res.send('Restarted')
  }catch(err){
    console.log(err)
    res.send('Already Started')
  }
})

app.get('/',function(req, res) {
  //console.log('NER Request received')
  res.send('You need to POST some json as {data:"XXXX"}')
  //console.log(process.uptime() - startTime, "ms for 23 lines")
})


app.post('/', function(req, res) {
  //console.log('NER Request received')
  var output = []
  var startTime = process.uptime()
  console.log(req)
  res.send(NER.getEntities(req.body.data, ""))
  //console.log(process.uptime() - startTime, "ms for 23 lines")
})

app.get('/close', function(req, res) {
  try{
    NER.close()
    res.send('Closed')
  }catch(err){
    console.log(err)
    res.send('Already Closed')
  }
})


var port = 8080
app.listen(port, function() {
  console.log('Micro-NER listening on port ' + port + '!');
});
