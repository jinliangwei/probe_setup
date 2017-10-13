#!/usr/local/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 num_hosts host_name_suffix"
    exit 0
fi

num_hosts=$(($1-1))
suffix=$2
project_dir=$(dirname $0)

hosts_file=$project_dir/hosts

nodes_file=$project_dir/nodes
> $nodes_file

echo "#" > $hosts_file
echo "# Hosts Database." >> $hosts_file
echo "#" >> $hosts_file
echo -e "127.0.0.1\tlocalhost loghost" >> $hosts_file

for i in $(seq 0 $num_hosts); do
    ip=$(host h${i}.${suffix} | grep -o '[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*')
    echo -e "$ip\th$i" >> $hosts_file
    echo "$ip" >> $nodes_file
done

echo -e "\n\n" >> $hosts_file

echo "# The following lines are desirable for IPv6 capable hosts" >> $hosts_file
echo "::1     localhost ip6-localhost ip6-loopback" >> $hosts_file
echo "ff02::1 ip6-allnodes" >> $hosts_file
echo "ff02::2 ip6-allrouters" >> $hosts_file
