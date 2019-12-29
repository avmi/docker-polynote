FROM buildpack-deps:stretch

LABEL maintainer="a@avm.name"

ENV PYTHON_VERSION=3.7

# Installing Conda
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.7.12-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda install -y python=$PYTHON_VERSION && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

# Installing Tini
ENV TINI_VERSION v0.18.0

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

WORKDIR /usr/src/app

ENV SPARK_VERSION=2.4.4
ENV HADOOP_VERSION=2.7
ENV SCALA_VERSION=2.11.12
ENV POLYNOTE_VERSION=0.2.14

# Installing JDK 8
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN apt-get update && apt-get install -y openjdk-8-jdk python3-dev

# Installing Python w/dependencies
RUN pip3 install jep
RUN conda install -y tensorflow pyspark virtualenv keras plotly
RUN conda install -y -c conda-forge jedi
RUN conda clean -y --all

# Installing Spark and Hadoop
RUN wget -q https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    && tar -zxvf spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz \
    && mv spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} /opt/spark \
    && rm spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz

# Installing Scala
RUN wget -q -O- "https://www.scala-lang.org/files/archive/scala-${SCALA_VERSION}.tgz" \
    | tar xzf - -C /usr/local --strip-components=1

ENV SPARK_HOME=/opt/spark
ENV PATH="$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin"

# Download and extract polynote
RUN curl -s -Lk https://github.com/polynote/polynote/releases/download/${POLYNOTE_VERSION}/polynote-dist.tar.gz \
    | tar -xzvpf -

RUN rm -rf \
    /tmp/* \
    /var/tmp/* \
    /usr/share/man \
    /usr/share/doc \
    /usr/share/doc-base \
    /root/.cache/pip

COPY polynote-config.yml ./polynote/config.yml

EXPOSE 8192

COPY ./start.sh /start.sh
RUN chmod +x /start.sh

CMD [ "/start.sh" ]

ENTRYPOINT ["/tini", "--"]
