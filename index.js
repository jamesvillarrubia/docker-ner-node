// Importing the module
var socketNER = require("ner-node")
var express = require('express');
var argv = require('minimist')(process.argv.slice(2));
var bodyParser = require('body-parser');
var app = express();
app.use(bodyParser.json()); // for parsing application/json

var NER = socketNER(1234, 'classifiers/english.muc.7class.distsim.crf.ser.gz', "./stanford-ner-2015-04-20/")
NER.init()
console.log('NER intialized')

app.get('/restart', function(req, res) {
  NER.init()
  res.send('Restarted')
})

app.post('/', function(req, res) {
  console.log('NER Request received')
  var output = []
  var startTime = process.uptime()
  //console.log(req.body)
  res.send(NER.getEntities(req.body.data, ""))
  console.log(process.uptime() - startTime, "ms for 23 lines")
})

app.get('/close', function(req, res) {
  NER.close()
  res.send('Closed')
})


var port = (typeof argv.port == 'undefined' ? 8080 : argv.port)
app.listen(port, function() {
  console.log('Micro-NER listening on port ' + port + '!');
});
