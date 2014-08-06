#Apache Hadoop 1.1.1 Docker image

# Build the image

If you'd like to try directly from the Dockerfile you can build the image as:

```
docker build -t="sequenceiq/hadoop-cluster-docker:1.1.1" .
```
# Pull the image
```
docker pull sequenceiq/hadoop-cluster-docker:1.1.1
```

# Start a container
command introduction
```
docker run   --net=host  sequenceiq/hadoop-cluster-docker:2.4.1 $1 $2 $3
Params definition as below:
$1:Type of Namenode or Datanode, such as N | D
$2:Master Node IP address, such as 10.28.241.174
$3:Default command, run as service "-d", run as interactive "-bash"

stop other hadoop docker
```
docker stop $(docker ps -a -q) 
docker rm $(docker ps -a -q)

start namenode as interactive
```
docker run -i -t --net="host" sequenceiq/hadoop-cluster-docker:1.1.1 N 10.28.241.174 -bash

```
start datanode as backend service
```
docker run  --net="host" sequenceiq/hadoop-cluster-docker:1.1.1 D 10.28.241.174 -d

start datanode as interactive
```
docker run -i -t  --net="host" sequenceiq/hadoop-cluster-docker:1.1.1 D 10.28.241.174 -bash

##check status
http://10.28.241.174:50070/dfsnodelist.jsp?whatNodes=LIVE

## Testing

create testing data
```
$HADOOP_PREFIX/bin/hadoop fs -mkdir -p /user/root
$HADOOP_PREFIX/bin/hadoop fs -put $HADOOP_PREFIX/conf/ input
#$HADOOP_PREFIX/bin/hadoop fs  -rm -r output

run sample testing
```
$HADOOP_PREFIX/bin/hadoop jar $HADOOP_PREFIX/hadoop-examples-1.1.1.jar wordcount input output

check the output
```
$HADOOP_PREFIX/bin/hadoop fs -cat output/*
