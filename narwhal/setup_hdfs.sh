#!/bin/bash

project_dir=$(dirname $(readlink -f $0))
hadoop_home=/users/jinlianw//hadoop-2.7.4/

cp $project_dir/slaves ${hadoop_home}/etc/hadoop/slaves

hdfs_namenode_dir=/l0/hdfs/name

if [ -f "${hdfs_namenode_dir}/current/VERSION" ]; then
    echo "Hadoop namenode appears to be formatted: skipping"
else
    echo "Formatting HDFS namenode..."
    ${hadoop_home}/bin/hdfs namenode -format
fi

${hadoop_home}/sbin/start-dfs.sh
