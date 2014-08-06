# Creates pseudo distributed hadoop 1.1.1
#
# docker build -t="sequenceiq/hadoop-cluster-docker:1.1.1" .

FROM tianon/centos:6.5
MAINTAINER SequenceIQ

USER root

# install dev tools
RUN yum install -y curl which tar sudo openssh-server openssh-clients rsync

# passwordless ssh
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys


# java
RUN curl -LO 'http://download.oracle.com/otn-pub/java/jdk/7u51-b13/jdk-7u51-linux-x64.rpm' -H 'Cookie: oraclelicense=accept-securebackup-cookie'
RUN rpm -i jdk-7u51-linux-x64.rpm
RUN rm jdk-7u51-linux-x64.rpm

ENV JAVA_HOME /usr/java/default
ENV PATH $PATH:$JAVA_HOME/bin

# hadoop
RUN curl -s http://archive.apache.org/dist/hadoop/core/hadoop-1.1.1/hadoop-1.1.1.tar.gz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s ./hadoop-1.1.1 hadoop

ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_HOME_WARN_SUPPRESS 1

RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/java/default\nexport HADOOP_PREFIX=/usr/local/hadoop\nexport HADOOP_HOME=/usr/local/hadoop\n:' $HADOOP_PREFIX/conf/hadoop-env.sh
RUN sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/conf/:' $HADOOP_PREFIX/conf/hadoop-env.sh
#RUN . $HADOOP_PREFIX/conf/hadoop-env.sh

RUN mkdir $HADOOP_PREFIX/input
RUN cp $HADOOP_PREFIX/conf/*.xml $HADOOP_PREFIX/input

# pseudo distributed
ADD core-site.xml $HADOOP_PREFIX/conf/core-site.xml
ADD hdfs-site.xml $HADOOP_PREFIX/conf/hdfs-site.xml
ADD mapred-site.xml $HADOOP_PREFIX/conf/mapred-site.xml
ADD masters $HADOOP_PREFIX/conf/masters
ADD slaves $HADOOP_PREFIX/conf/slaves


#configure ssh
ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config
RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config

#add bootstrap.sh
ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh
ENV BOOTSTRAP /etc/bootstrap.sh

# configure *-env.sh
RUN ls -la   /usr/local/hadoop/conf/*-env.sh
RUN chmod +x /usr/local/hadoop/conf/*-env.sh
RUN ls -la   /usr/local/hadoop/conf/*-env.sh

# fixing the libhadoop.so like a boss
#RUN rm  /usr/local/hadoop/lib/native/*
#RUN curl -Ls http://dl.bintray.com/sequenceiq/sequenceiq-bin/hadoop-native-64-2.4.1.tar|tar -x -C /usr/local/hadoop/lib/native/

#prepare the testing files.
#RUN $HADOOP_PREFIX/bin/hadoop namenode -format
#RUN service sshd start && $HADOOP_PREFIX/conf/hadoop-env.sh && $HADOOP_PREFIX/bin/start-dfs.sh && $HADOOP_PREFIX/bin/hadoop fs -mkdir -p /user/root
#RUN service sshd start && $HADOOP_PREFIX/conf/hadoop-env.sh && $HADOOP_PREFIX/bin/start-dfs.sh && $HADOOP_PREFIX/bin/hadoop fs -put $HADOOP_PREFIX/conf/ input


EXPOSE 50030 50020 50021 50090 50070 50010 50011 50075 50076 8031 8032 8033 8040 8042 49707 22 8088 8030

CMD ["-h"]
ENTRYPOINT ["/etc/bootstrap.sh"]
