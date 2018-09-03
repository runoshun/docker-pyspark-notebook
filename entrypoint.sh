#!/bin/bash

launch_hdfs_namenode() {
    mkdir -p /tmp/hadoop-root/dfs/name/
    ${HADOOP_HOME}/bin/hdfs namenode -format
    ${HADOOP_HOME}/bin/hdfs namenode $*
}

launch_hdfs_datanode() {
    ${HADOOP_HOME}/bin/hdfs datanode $*
}

command=$1
shift;

case ${command} in
    notebook) cd /home/notebook && su -c "jupyter notebook --ip 0.0.0.0" notebook;;
    jupyter) cd /home/notebook && su -c "jupyter notebook --ip 0.0.0.0" notebook;;
    spark-master) ${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.master.Master $*;;
    spark-worker) ${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.worker.Worker $*;;
    hdfs-namenode) launch_hdfs_namenode $*;;
    hdfs-datanode) launch_hdfs_datanode $*;;
    *) /bin/bash -c "${command} $*"
esac