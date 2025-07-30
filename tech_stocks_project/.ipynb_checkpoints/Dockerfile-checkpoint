FROM bitnami/spark:latest

USER root

RUN apt-get update && \
    apt-get install -y python3 python3-pip bash gawk && \
    pip3 install pandas matplotlib seaborn jupyter

USER 1001

WORKDIR /app

COPY . /app

CMD ["/bin/bash"]