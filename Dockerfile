FROM anapsix/alpine-java
MAINTAINER ViZix "service@mojix.com"

RUN apk add --update unzip wget curl docker jq coreutils

ENV HADOOP_VERSION="2.7.3"

COPY download-hadoop.sh /tmp/download-hadoop.sh

RUN /tmp/download-hadoop.sh && tar xfz /tmp/hadoop-${HADOOP_VERSION}.tar.gz -C /opt && rm /tmp/hadoop-${HADOOP_VERSION}.tar.gz

VOLUME ["/hadoop"]

ENV HADOOP_HOME="/opt/hadoop-${HADOOP_VERSION}"

RUN apk add --update openssh

COPY core-site.xml $HADOOP_HOME/etc/hadoop
COPY hdfs-site.xml $HADOOP_HOME/etc/hadoop
COPY start-dfs.sh $HADOOP_HOME/sbin
COPY run.sh /run.sh

EXPOSE 8080 8081
ENTRYPOINT ["/run.sh"]
