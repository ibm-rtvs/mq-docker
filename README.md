# mq-docker
A sample demonstrating how to build an MQ Broker docker image containing the RTVS MQ Exit for message interception.

This example is an adapted version taken from [ibm-messaging](https://github.com/ibm-messaging/mq-docker).

# Steps

1\. Clone the example
```
git clone https://github.com/ibm-rtvs/mq-docker.git
```
2\. Make changes as necessary

3\. Build the image
```
cd mq-docker
wget http://localhost:7819/RTCP/rest/tools/IBM/WebSphereMQ/dist/IBMWebSphereMQdist.zip
docker build -t mq-docker .
```
4\. Execute the image
```
docker run -d -e LICENSE=accept -e MQ_QMGR_NAME=QM1 -p 1414:1414 mq-docker
```

You now have a running IBM MQ Broker with Intercept installed.

#Connection details
The default configured connection details are:

* Host: The hostname or ip address of the docker host. If you're using Docker Machine you can find this using ```$(docker-machine ip)```
* Queue Manager: ```QM1```
* Port: ```1414```
* Channel: ```PASSWORD.SVRCONN```
* Username: ```alice```
* Password: ```passw0rd```
* Queue: ```sample```

You should configure MQ transports used by IBM Rational Integration Tester to use **Dynamic Queues** in both **Recording** and **Stubbing** tabs to enable message interception.
