FROM ubuntu:bionic

# showing to hadoop and spark where to find java!
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64/jre
​
# after downloading hadoop (a bit further) we have to inform any concerned
# app where to find it
ENV HADOOP_HOME=/opt/hadoop
​
# same for the hadoop configuration
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
​
# and same for spark
ENV SPARK_HOME=/opt/spark
​
# with this we can run all hadoop and spark scripts and commands directly from the shell
# without using the absolute path
ENV PATH="${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${PATH}"
​
# just informing the hadoop version, this isn't really necessary
ENV HADOOP_VERSION=2.7.0
​
# if you happend to run pyspark from shell, it will launch it on a Jupyter Notebook
# this is just two fancy lines, really no need for it
ENV PYSPARK_DRIVER_PYTHON=jupyter
ENV PYSPARK_DRIVER_PYTHON_OPTS='notebook'
​
# showing pyspark which "python" command to use
ENV PYSPARK_PYTHON=python3

RUN apt-get update && apt-get install -y \
    wget nano openjdk-8-jdk ssh openssh-server \
    python3 python3-pip python3-dev build-essential \
    libssl-dev libffi-dev libpq-dev

COPY /confs/requirements.req /
RUN pip3 install -r requirements.req
RUN pip3 install dask[bag] --upgrade
RUN pip3 install --upgrade toree
RUN python3 -m bash_kernel.install

# Download Hadoop 3.4.1
RUN wget -P /tmp/ https://dlcdn.apache.org/hadoop/common/hadoop-3.4.1/hadoop-3.4.1.tar.gz

# Extract Hadoop and move to /opt
RUN tar xvf /tmp/hadoop-3.4.1.tar.gz -C /tmp && \
    mv /tmp/hadoop-3.4.1 /opt/hadoop

# Download Spark 
RUN wget -P /tmp/ https://dlcdn.apache.org/spark/spark-3.5.6/spark-3.5.6-bin-hadoop3.tgz

# Extract Spark and move to $SPARK_HOME
RUN tar xvf /tmp/spark-3.5.6-bin-hadoop3.tgz -C /tmp && \
    mv /tmp/spark-3.5.6-bin-hadoop3 ${SPARK_HOME}

# Generate SSH key pair for root user (without passphrase)
RUN mkdir -p /root/.ssh && \
    ssh-keygen -t rsa -b 4096 -f /root/.ssh/id_rsa -P "" && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys

# Copy SSH config file and set permissions
COPY /confs/config /root/.ssh/
RUN chmod 600 /root/.ssh/config

COPY /confs/*.xml /opt/hadoop/etc/hadoop/
COPY /confs/slaves /opt/hadoop/etc/hadoop/
COPY /script_files/bootstrap.sh /
COPY /confs/spark-defaults.conf ${SPARK_HOME}/conf
RUN chmod +x /bootstrap.sh

# HDFS, Spark, Spark UI, HDFS, SSH, Juypyter, ResourceManager UI
EXPOSE 9000
EXPOSE 7077
EXPOSE 4040
EXPOSE 8020
EXPOSE 22
EXPOSE 8888
EXPOSE 8088

RUN mkdir lab
COPY notebooks/*.ipynb /root/lab/
COPY datasets /root/lab/datasets
​
ENTRYPOINT ["/bin/bash", "bootstrap.sh"]
