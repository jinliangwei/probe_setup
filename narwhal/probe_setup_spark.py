import sys
import os
import subprocess

# assumptions:
# 1) the project directory is on a shared NFS among all nodes

def ssh_command():
    args = ['-o', 'StrictHostKeyChecking=no']
    args += ['-o', 'UserKnownHostsFile=/dev/null']
    return ['ssh'] + args

def ssh(host, command):
    return subprocess.check_call(ssh_command() + [host, command])

if __name__ == "__main__":
    if len(sys.argv) != 3 and len(sys.argv) != 2:
        print "Usage: %s num-hosts host-suffix || %s shutdown" % (sys.argv[0], sys.argv[0])
        exit(1)

    project_dir = os.path.dirname(os.path.abspath(sys.argv[0]))
    if len(sys.argv) == 2 and sys.argv[1] == "shutdown":
        with open(project_dir + "/nodes", "r") as nodes_fobj:
            master_ip = nodes_fobj.readline().strip()
        ssh(master_ip, "/users/jinlianw/spark-2.2.0-bin-hadoop2.7/sbin/stop-slaves.sh")
        ssh(master_ip, "/users/jinlianw/spark-2.2.0-bin-hadoop2.7/sbin/stop-master.sh")
        ssh(master_ip, "/users/jinlianw/hadoop-2.7.4/sbin/stop-dfs.sh")
        exit(1)

    num_hosts = int(sys.argv[1])
    host_suffix = sys.argv[2]

    gen_hosts = project_dir + "/gen_hosts.sh"
    os.system("bash " + gen_hosts + " %s %s" % (str(num_hosts), host_suffix))

    with open(project_dir + "/slaves", "w") as slaves_fobj:
        for i in range(1, num_hosts):
            slaves_fobj.write("h%d\n" % i)

    print "Create hosts file --- done"
    with open(project_dir + "/nodes", "r") as nodes_fobj:
        master = True
        for line in nodes_fobj:
            print line.strip()
            ssh(line.strip(), "sudo cp %s/hosts /etc/hosts" % project_dir)
            if master:
                master_ip = line.strip()
                master = False

    print "Create nodes file --- done"
    #    ssh(master_ip, "%s/setup_cluster.sh" % project_dir)
    #    print "Set up cluster nodes --- done"
    print "master is %s " % master_ip
    ssh(master_ip, "%s/setup_hdfs.sh" % project_dir)
    print "Set up HDFS --- done"
    ssh(master_ip, "%s/setup_spark.sh" % project_dir)
    print "Set up Spark --- done"
