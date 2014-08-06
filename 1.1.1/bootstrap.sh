#!/bin/bash
env

: ${HADOOP_PREFIX:=/usr/local/hadoop}
$HADOOP_PREFIX/conf/hadoop-env.sh

rm /tmp/*.pid

#IP=`ifconfig eth0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " "`
#echo "ipaddress=$IP"

# print the params
echo "Namenode or datanode:$1"
echo "Master ip:$2"
echo "Default command:$3"


# altering the core-site,hdfs-site,mapred-sit configuration
sed -i s/__MASTER__/$2/ /usr/local/hadoop/conf/core-site.xml
sed -i s/__MASTER__/$2/ /usr/local/hadoop/conf/mapred-site.xml

#start NameNode and DataNode

cd $HADOOP_HOME
service sshd start

if [ $1 = "N" ] ; then
    echo "starting Hadoop Namenode,Jobtracker"
    #rm -rf  /tmp/hadoop-root
    $HADOOP_PREFIX/bin/hadoop namenode -format > /dev/null 2>&1
    echo "format namenode"
    
    $HADOOP_PREFIX/bin/hadoop-daemon.sh start namenode
    echo "start namenode"
	
    $HADOOP_PREFIX/bin/hadoop-daemon.sh start jobtracker
    echo "start jobtracker"

    #$HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave
    
else
    echo "starting Hadoop Datanode"
    
    $HADOOP_PREFIX/bin/hadoop-daemon.sh start datanode  > /dev/null 2>&1
    echo "start datanode"
    
    $HADOOP_PREFIX/bin/hadoop-daemon.sh start tasktracker  > /dev/null 2>&1
    echo "start tasktracker"
fi

if [[ $3 == "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $3 == "-bash" ]]; then
  /bin/bash
fi


