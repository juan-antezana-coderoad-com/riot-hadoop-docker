#!/bin/sh

#http://www-eu.apache.org/dist/hadoop/common/hadoop-2.7.3/hadoop-2.7.3.tar.gz
url="http://www-eu.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz"
wget -q "${url}" -O "/tmp/hadoop-${HADOOP_VERSION}.tar.gz"