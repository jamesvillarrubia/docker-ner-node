// Importing the module
var socketNER = require("ner-node")
var express = require('express');
var bodyParser = require('body-parser');
var app = express();
app.use(bodyParser.json()); // for parsing application/json

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

var NER = socketNER(1234, 'classifiers/english.muc.7class.distsim.crf.ser.gz', "./stanford-ner-2018-10-16/")
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
  //console.log(process.uptime() - startTime, "ms for 23 lines")

  if (req.query.testcrash == 'true') {
    setTimeout(function(){
        undefined.crashMe();
    }, 100);
  }//console.log('NER Request received')

  res.send('You need to POST some json as {data:"XXXX"} or this will not work')

})


app.post('/', function(req, res) {
  

  var output
  var startTime = process.uptime()
  try{
    output = NER.getEntities(req.body.data, "")
  }catch(err){
    NER.init()
    output = NER.getEntities(req.body.data, "")
  }
  res.send(output)
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
