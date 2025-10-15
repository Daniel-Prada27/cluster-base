#!/bin/bash

service ssh start

if [ "$HOSTNAME" = "node-master" ]; then
    # Format namenode only if not already formatted
    if [ ! -d "/opt/hadoop/dfs/name" ]; then
        echo "Formatting namenode..."
        hdfs namenode -format -force
    fi

    # Ensure SSH access to all nodes
    ssh-keyscan -H node-master node-slave1 node-slave2 >> /root/.ssh/known_hosts

    echo "Starting HDFS..."
    start-dfs.sh
    echo "Starting YARN..."
    start-yarn.sh

    echo "Starting Jupyter..."
    cd /root/lab
    jupyter trust *.ipynb
    jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root
else
    echo "Slave node ready: $HOSTNAME"
    tail -f /dev/null
fi



