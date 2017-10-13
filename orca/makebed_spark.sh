setup_dir=$(dirname $(readlink -f $0))

echo $setup_dir

/share/probe/bin/probe-makebed -p BigLearning -e $1 -i jwSparkU16 \
    -s ${setup_dir}/jinlianw-startup \
    -n $2
