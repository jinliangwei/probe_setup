#!/bin/bash

device=$1
mount_pt=$2

sudo mkfs.ext4 -E lazy_itable_init=0,lazy_journal_init=0 ${device}
sudo mkdir ${mount_pt}
sudo mount -o defaults,noatime,nodiratime ${device} ${mount_pt}
sudo chown -R jinlianw:BigLearning ${mount_pt}
