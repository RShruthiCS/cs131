# Use bitnami spark base image
FROM bitnami/spark:latest

# Switch to root to install packages
USER root

RUN apt-get update && \
    apt-get install -y python3 python3-pip bash gawk && \
    pip3 install pandas matplotlib seaborn

# Switch back to default non-root user (bitnami user 1001)
USER 1001

# Set working directory inside container
WORKDIR /app

# Copy local project files into container
COPY . /app

# Default command to run bash
CMD ["/bin/bash"]

