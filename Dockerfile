# Based on instructions here: https://www.vultr.com/docs/setup-nginx-rtmp-on-ubuntu-14-04
# Using Ubuntu 18.04 (bionic)

FROM ubuntu:bionic
ENV NGINX_VERSION 1.17.9

# https://launchpad.net/~savoury1/+archive/ubuntu/ffmpeg4
RUN apt-get update && \
    apt-get -y install software-properties-common && \
    add-apt-repository ppa:savoury1/graphics && \
    add-apt-repository ppa:savoury1/multimedia && \
    add-apt-repository ppa:savoury1/ffmpeg4 && \
    add-apt-repository ppa:savoury1/build-tools && \
    add-apt-repository ppa:savoury1/backports && \
    apt-get update && \
    apt-get -y dist-upgrade && \
    apt-get -y install \
      build-essential \
    	libpcre3 \
    	libpcre3-dev \
    	libssl-dev \
    	zlib1g-dev \
    	unzip \
      ffmpeg && \
    apt-get clean

WORKDIR /build

COPY nginx.tar.gz .
COPY nginx-rtmp-module.zip .

RUN tar -xf nginx.tar.gz
RUN unzip nginx-rtmp-module.zip

RUN cd nginx-${NGINX_VERSION} && ./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master
RUN cd nginx-${NGINX_VERSION} && make
RUN cd nginx-${NGINX_VERSION} && make install

COPY stat.xsl /opt/multistream/stat.xsl/stat.xsl
RUN chmod -R a+r /opt/multistream

WORKDIR /opt/multistream

RUN apt-get clean
RUN rm -rf /build

EXPOSE 1935 8080
CMD ["/usr/local/nginx/sbin/nginx"]
