# FROM phusion/baseimage:0.11
FROM arm32v7/debian:jessie-slim
MAINTAINER R0GGER

ENV DEBIAN_FRONTEND="noninteractive" HOME="/root" TERM="xterm"
ENV PATH /app/mistserver:$PATH
# ENV MISTSERVER=https://r.mistserver.org/dl/mistserver_64V2.14.1.tar.gz
# replace Mistserver package link with the ARM one
ENV MISTSERVER=https://r.mistserver.org/dl/mistserver_armv7V2.14.2.tar.gz

# install basics
RUN apt-get update
RUN apt-get install wget -yq
RUN mkdir -p /app/mistserver /config /media
ADD service/ /etc/service/
RUN chmod -v +x /etc/service/*/run

# install mistserver
RUN wget -qO- ${MISTSERVER} | tar xvz -C /app/mistserver

# clean up
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

VOLUME /config /media
EXPOSE 4242 8080 1935 554
CMD ["/bin/bash", "-c", "echo 'n' | /usr/bin/MistController -c /config/server.conf"]


# docker run -d --restart=always --net=host -v <path to video>:/media --name r0gger/mistserver 
