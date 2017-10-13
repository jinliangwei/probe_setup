#!/bin/bash
project_dir=$(dirname $(readlink -f $0))

sudo apt-get install -y -q pssh
${project_dir}/setup_local_fs.sh /dev/sda /l0
parallel-ssh \
    -t 0 -h $project_dir/slaves "${project_dir}/setup_local_fs.sh /dev/sda /l0"

${project_dir}/setup_local_fs.sh /dev/nvme0n1 /l1
parallel-ssh \
    -t 0 -h $project_dir/slaves "${project_dir}/setup_local_fs.sh /dev/nvme0n1 /l1"

sudo mkdir -p /datasets
sudo mount otto-02:/vol/datasets /datasets

parallel-ssh -h $project_dir/slaves "sudo mkdir -p /datasets"
parallel-ssh -h $project_dir/slaves "sudo mount otto-02:/vol/datasets /datasets"
