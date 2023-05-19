FROM ubuntu

# FROM quay.io/school21/alpine:3.16


RUN apt-get -y update; apt-get -y install valgrind; apt-get -y install check; apt-get -y install gcc; apt-get -y install make; mkdir -p /usr/src/; apt-get -y install zsh

WORKDIR /usr/src/

COPY . .

# RUN apk add \
#     bash \
#     valgrind \
#     alpine-sdk \
