FROM anapsix/alpine-java
MAINTAINER ViZix "service@mojix.com"
USER root
RUN apk add --update unzip wget curl docker jq openssh coreutils

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
