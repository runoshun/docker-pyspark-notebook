#!/bin/bash

launch_hdfs_namenode() {
    mkdir -p /tmp/hadoop-root/dfs/name/
    ${HADOOP_HOME}/bin/hdfs namenode -format
    ${HADOOP_HOME}/bin/hdfs namenode $*
}

launch_hdfs_datanode() {
    ${HADOOP_HOME}/bin/hdfs datanode $*
}
export PATH=${PATH}:${HADOOP_HOME}/bin:${SPARK_HOME}/bin
export PYSPARK_PYTHON=/usr/bin/python
export PYSPARK_DRIVER_PYTHON=/usr/bin/python
export PYTHONPATH=`ls ${SPARK_HOME}/python/lib/py4j-*`:${SPARK_HOME}/python:$PYTHONPATH
export PYTHONIOENCODING=UTF-8
export PIP_DISABLE_PIP_VERSION_CHECK=1

if hash hadoop 2>/dev/null; then
    export SPARK_DIST_CLASSPATH=$(hadoop classpath)
fi


command=$1
shift;

case ${command} in
    notebook) cd /home/notebook && su -c "jupyter notebook --ip 0.0.0.0" notebook;;
    jupyter) cd /home/notebook && su -c "jupyter notebook --ip 0.0.0.0" notebook;;
    jupyter-lab) cd /home/notebook && su -c "jupyter lab --ip 0.0.0.0" notebook;;
    spark-master) ${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.master.Master $*;;
    spark-worker) ${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.worker.Worker $*;;
    hdfs-namenode) launch_hdfs_namenode $*;;
    hdfs-datanode) launch_hdfs_datanode $*;;
    *) /bin/bash -c "${command} $*"
esac
