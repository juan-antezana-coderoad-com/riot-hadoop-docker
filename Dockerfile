FROM anapsix/alpine-java
MAINTAINER ViZix "service@mojix.com"
USER root
RUN apk add --update unzip wget curl docker jq openssh rsync coreutils

# passwordless ssh
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ed25519_key
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# Disable IPv6
CMD sysctl -w net.ipv6.conf.default.disable_ipv6=1
CMD sysctl -w net.ipv6.conf.all.disable_ipv6=1
RUN echo "net.ipv6.conf.default.disable_ipv6=1" >> /etc/sysctl.conf
RUN echo "net.ipv6.conf.all.disable_ipv6=1" >> /etc/sysctl.conf

# Download Hadoop 2.7.3
ENV HADOOP_VERSION="2.7.3"
ADD download-hadoop.sh /tmp/download-hadoop.sh
CMD /tmp/download-hadoop.sh && \
    gunzip /tmp/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar -xf /tmp/hadoop-${HADOOP_VERSION}.tar -C /opt && \
    rm /tmp/hadoop-${HADOOP_VERSION}.tar

VOLUME ["/hadoop"]

ENV HADOOP_PREFIX="/opt/hadoop-${HADOOP_VERSION}"
ENV HADOOP_COMMON_HOME=$HADOOP_PREFIX
ENV HADOOP_HDFS_HOME=$HADOOP_PREFIX
ENV HADOOP_MAPRED_HOME=$HADOOP_PREFIX
ENV HADOOP_YARN_HOME=$HADOOP_PREFIX
ENV HADOOP_CONF_DIR=$HADOOP_PREFIX/etc/hadoop
ENV YARN_CONF_DIR=$HADOOP_PREFIX/etc/hadoop

CMD mkdir $HADOOP_PREFIX/input $HADOOP_PREFIX/logs && \
	CP $HADOOP_PREFIX/etc/hadoop/*.xml $HADOOP_PREFIX/input && \
	RM $HADOOP_PREFIX/etc/hadoop/core-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml && \
	CHMOD +x $HADOOP_PREFIX/etc/hadoop/*.sh

# Copy the custom configurations.
ADD core-site.xml $HADOOP_PREFIX/etc/hadoop
ADD mapred-site.xml $HADOOP_PREFIX/etc/hadoop
ADD hdfs-site.xml $HADOOP_PREFIX/etc/hadoop
ADD start-dfs.sh $HADOOP_PREFIX/sbin
ADD start-yarn.sh $HADOOP_PREFIX/sbin

# Create a temporary area for Hadoop file system
CMD mkdir /root/hadoopfs
CMD mkdir /root/hadoopfs/tmp

# Format the HDFS filesystem using the NameNode.
CMD $HADOOP_PREFIX/bin/hadoop namenode -format

ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

ADD run.sh /run.sh

# Hdfs ports
EXPOSE 50010 50020 50070 50075 50090 8020 9000
# Mapred ports
EXPOSE 19888
#Yarn ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088
#Other ports
EXPOSE 49707 2122

ENTRYPOINT ["/run.sh"]
