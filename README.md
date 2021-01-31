# haproxy-wi-docker-ubuntu
Dockerfile to create an Ubuntu 20.04 based HAProxy container with web based administration

# Usage
## Build container image
    docker build -t haproxy-ubuntu-wi .
## Run container
    docker run -dp 443:443 haproxy-ubuntu-wi
