setup_dir=$(dirname $(readlink -f $0))
echo $setup_dir
/share/testbed/bin/rr-makebed -p BigLearning -e $1 -i jwSparkU14 \
			      -s ${setup_dir}/jinlianw-startup \
			      -n $2
