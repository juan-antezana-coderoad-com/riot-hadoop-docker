#!/bin/bash
ls -la $HADOOP_PREFIX

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

# start namenode
$HADOOP_PREFIX/sbin/start-all.sh

# Start SSHD
echo "Starting sshd"
/usr/sbin/sshd -D