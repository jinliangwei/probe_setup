#!/bin/bash

project_dir=$(dirname $(readlink -f $0))
spark_home=/users/jinlianw/spark-2.1.0-bin-hadoop2.7/
hadoop_home=/users/jinlianw//hadoop-2.7.4/

cp $project_dir/slaves ${spark_home}/conf/slaves
${hadoop_home}/bin/hdfs dfs -mkdir /spark_eventlog

# Start Master
${spark_home}/sbin/start-master.sh

# Pause
sleep 20

# Start Workers
${spark_home}/sbin/start-slaves.sh
${spark_home}/sbin/start-history-server.sh
