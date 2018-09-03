FROM gettyimages/spark:spark-2.3.1-hadoop-3.0.0

RUN pip install \
     numpy \
     scipy \
     matplotlib \
     pandas \
     scikit-learn \
     seaborn \
     bokeh \
     jupyter \
     ipywidgets \
     sympy \
     jupyter_contrib_nbextensions

ENV PYSPARK_PYTHON=/usr/bin/python \
    PYSPARK_DRIVER_PYTHON=/usr/bin/python \
    PYTHONPATH=${SPARK_HOME}/python/lib/py4j-0.10.7-src.zip):${SPARK_HOME}/python:$PYTHONPATH \
    PATH=${PATH}:${HADOOP_HOME}/bin:${SPARK_HOME}/bin
RUN useradd -m notebook
RUN jupyter contrib nbextension install

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
