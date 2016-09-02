#!/bin/bash
ls -la $HADOOP_PREFIX

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

/bin/rm -rf /tmp/*.pid

# Get hostname/ip config
HOST_NAMENODE="10.100.1.67"
echo "Current Hostname: " $HOST_NAMENODE
if [ ! -e  $HADOOP_PREFIX/etc/hadoop/core-site.xml ]
then
  	echo "Changing Hostname in core-site.xml"
	sed s/HOSTNAME/$HOST_NAMENODE/ $HADOOP_PREFIX/etc/hadoop/core-site.xml.template > $HADOOP_PREFIX/etc/hadoop/core-site.xml
    sed s/HOSTNAME/$HOST_NAMENODE/ $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml.template > $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
else
	echo "core-site.xml: "
	cat $HADOOP_PREFIX/etc/hadoop/core-site.xml
fi

# format namenode...need to check this
if [ ! -d /hdfs/volume1/name/current ]; then
	echo "Formatting namenode"
	$HADOOP_PREFIX/bin/hdfs namenode -format
else
	echo "It Appears this namenode is ready. Skipping format."
fi

# start namenode
$HADOOP_PREFIX/sbin/hadoop-daemon.sh start namenode

# start namenode
$HADOOP_PREFIX/sbin/hadoop-daemon.sh start secondarynamenode

# Start SSHD
echo "Starting sshd"
exec /usr/sbin/sshd -D

if [[ $1 == "-d" ]]; then
  while true; do sleep 1000; done
fi
