#!/bin/bash

# Format the HDFS Namenode if it hasn't been formatted already
hdfs namenode -format

# Start SSH service
service ssh start

# Start Hadoop and YARN services on the master node
if [ "$HOSTNAME" = "node-master" ]; then
    # Start HDFS and YARN services
    start-dfs.sh && start-yarn.sh
    echo "Hadoop and YARN started successfully on the master node."

    # Start Jupyter notebook (no token and no password for access)
    cd /root/lab
    jupyter trust Bash-Interface.ipynb
    jupyter trust Dask-Yarn.ipynb
    jupyter trust Python-Spark.ipynb
    jupyter trust Scala-Spark.ipynb

    # Launch Jupyter Notebook server in the foreground
    jupyter notebook --ip=0.0.0.0 --port=8888 --no-browser --allow-root
else
    echo "This is a slave node, skipping DFS and YARN startup."
fi
