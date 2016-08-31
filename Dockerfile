FROM anapsix/alpine-java
MAINTAINER ViZix "service@mojix.com"
USER root
RUN apk add --update unzip wget curl docker jq openssh coreutils

# passwordless ssh
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ed25519_key
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

ENV HADOOP_VERSION="2.7.3"
ADD download-hadoop.sh /tmp/download-hadoop.sh
RUN /tmp/download-hadoop.sh && tar xfz /tmp/hadoop-${HADOOP_VERSION}.tar.gz -C /opt && rm /tmp/hadoop-${HADOOP_VERSION}.tar.gz

VOLUME ["/hadoop"]

ENV HADOOP_HOME="/opt/hadoop-${HADOOP_VERSION}"

ADD core-site.xml $HADOOP_HOME/etc/hadoop
ADD hdfs-site.xml $HADOOP_HOME/etc/hadoop
ADD start-dfs.sh $HADOOP_HOME/sbin
ADD run.sh /run.sh

EXPOSE 8080 8081
ENTRYPOINT ["/run.sh"]