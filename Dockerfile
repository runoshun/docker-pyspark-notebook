FROM gettyimages/spark:2.3.1-hadoop-3.0

# install libgomp1 for xgboost
RUN apt-get update \
 && apt-get install -y libgomp1 \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
     numpy \
     scipy \
     matplotlib \
     pandas \
     scikit-learn \
     seaborn \
     bokeh \
     jupyter \
     jupyterlab \
     ipywidgets \
     sympy \
     xgboost \
     jupyter_contrib_nbextensions

ENV PYSPARK_PYTHON=/usr/bin/python \
    PYSPARK_DRIVER_PYTHON=/usr/bin/python \
    PYTHONPATH=${SPARK_HOME}/python/lib/py4j-0.10.7-src.zip):${SPARK_HOME}/python:$PYTHONPATH \
    PATH=${PATH}:${HADOOP_HOME}/bin:${SPARK_HOME}/bin
RUN useradd -m notebook
RUN jupyter contrib nbextension install

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
