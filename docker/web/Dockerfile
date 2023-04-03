FROM ubuntu
LABEL maintainer="jujin1324@daum.net"
LABEL dockerhub="https://hub.docker.com/_/ubuntu"

RUN ["apt", "update"]

# install basic tools
RUN ["apt", "install", "-y", "curl"]
RUN ["apt", "install", "-y", "vim"]
RUN ["apt", "install", "-y", "wget"]

# install java 11
RUN ["apt", "install", "-y", "openjdk-11-jdk"]

# install nginx
RUN ["apt", "install", "-y", "nginx"]
ADD nginx/starter.conf /etc/nginx/conf.d/
ADD nginx/service-url.inc /etc/nginx/conf.d/

# deploy application
RUN ["mkdir", "-p", "/home/ec2-user/nginx-starter/zip"]
ADD nginx-starter-0.0.1-SNAPSHOT.jar /home/ec2-user/nginx-starter/zip/
ADD scripts /home/ec2-user/nginx-starter/scripts/

# start.sh
ADD start.sh /
CMD ["sh", "start.sh"]
