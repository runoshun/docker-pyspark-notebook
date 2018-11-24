FROM openjdk:8-jdk

RUN apt-get update \
 && apt-get install -y curl unzip \
    python3 python3-setuptools \
 && rm /usr/bin/python \
 && ln -s /usr/bin/python3 /usr/bin/python \
 && easy_install3 pip py4j \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# HADOOP
ARG HADOOP_VERSION
ENV HADOOP_HOME=/usr/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop
RUN if [ "$HADOOP_VERSION" != "" ]; then \
    curl -sL --retry 3 \
    "http://archive.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz" \
    | gunzip \
    | tar -x -C /usr/ \
    && rm -rf $HADOOP_HOME/share/doc \
    && chown -R root:root $HADOOP_HOME; \
  fi

# SPARK
ARG SPARK_VERSION
ARG SPARK_PACKAGE
ENV SPARK_HOME=/usr/spark-${SPARK_VERSION}
RUN curl -sL --retry 3 \
  "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz" \
  | gunzip \
  | tar x -C /usr/ \
 && mv /usr/$SPARK_PACKAGE $SPARK_HOME \
 && chown -R root:root $SPARK_HOME

# HADOOP AWS
ARG HADOOP_AWS_VERSION
RUN if [ "$HADOOP_AWS_VERSION" != "" ]; then \
        java -jar `ls $SPARK_HOME/jars/ivy*` \
         -dependency org.apache.hadoop hadoop-aws $HADOOP_AWS_VERSION \
         -retrieve "$SPARK_HOME/jars/[artifact]-[revision].[ext]" \
         -types jar \
         -mode runtime; \
    fi

# install libgomp1 for xgboost
RUN apt-get update \
 && apt-get install -y libgomp1 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
     toree \
     numpy \
     scipy \
     matplotlib \
     pandas \
     scikit-learn==0.20.0 \
     seaborn \
     bokeh \
     jupyter \
     jupyterlab \
     ipywidgets \
     sympy \
     xgboost \
     jupyter_contrib_nbextensions

RUN useradd -m notebook
RUN jupyter contrib nbextension install
RUN jupyter toree install --spark_home=${SPARK_HOME} --interpreters=Scala,SQL

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
