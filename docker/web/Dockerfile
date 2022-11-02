FROM ubuntu
LABEL maintainer="jujin1324@daum.net"
LABEL dockerhub="https://hub.docker.com/_/ubuntu"

RUN ["apt", "update"]
RUN apt install -y sudo curl vim wget \
    openjdk-11-jdk \
    nginx

# setting nginx
ADD nginx/application.conf /etc/nginx/conf.d/
ADD nginx/service-url.inc /etc/nginx/conf.d/

# deploy application
RUN ["mkdir", "-p", "/home/ec2-user/nginx-starter/zip"]
ADD nginx-starter-0.0.1-SNAPSHOT.jar /home/ec2-user/nginx-starter/zip/
ADD scripts /home/ec2-user/nginx-starter/scripts/
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf

CMD ["nginx"]
