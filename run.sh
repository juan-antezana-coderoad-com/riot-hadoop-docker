#!/bin/bash

ls -la $HADOOP_PREFIX

echo Starting ssh server
/usr/sbin/sshd

# Start the services.
source $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh