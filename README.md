#Docker NER-node

This container spins up a Docker container at port 4321, talking to a Node Express engine at port 8080, which is managing a set of child spawns of the Stanford NER library at port 1234.  Docker prevents install mistakes.  Node/Express handle the json formatting and easy to configure API endpoints and pools/threads.  Stanford handles the rest of it. Not the most elegant, but it works and it works fast.  Great for dev projects and small efforts.  Needs work before large scale production roll out.  If you are using this in production, you should probably get someone to load the Java runtime directly in a scalable pool... just saying :)

### Installing
I'm assuming you've got docker installed, etc. From the command line:

```
docker run jamesmtc/ner-node
```

It will then download the Node container, install JAVA 8 JDK, and the NER library, and then kick off the app.

The app is running on port 8080.


### Running the full stack
To run the docker image on localhost:4321, I use the command

```
docker run -p 4321:8080 jamesmtc/ner-node
```

or to run in the background

```
docker run -it -p 4321:8080 jamesmtc/ner-node
```


### Example Calls

There are three endpoints available now at port 4321

POST - localhost:4321/
GET - localhost:4321/close
GET - localhost:4321/restart

To POST data and receive a response, send a JSON request with your string as the "data" property:
```json
{"data":"This sentence is going to get parsed and JP Morgan will be pulled out"}
```
which should return
```json
{
  "ORGANIZATION": [
    "JP Morgan"
  ]
}
```

### Stopping/Starting
To stop the NER node child processes(managing the JAVA processes), just request the /close endpoint
To restart it... just send a GET request to /restart

### Known bugs 
GET /restarts with a running process may cause faults. PR's are welcome to make this code a bit more robust.




