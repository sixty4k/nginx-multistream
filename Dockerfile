# Based on instructions here: https://www.vultr.com/docs/setup-nginx-rtmp-on-ubuntu-14-04
# Using Ubuntu 18.04 (bionic)

FROM ubuntu:bionic
ENV NGINX_VERSION 1.17.9

# https://launchpad.net/~savoury1/+archive/ubuntu/ffmpeg4
RUN apt-get update && \
    apt-get -y install \
        software-properties-common \
        wget && \
    add-apt-repository ppa:savoury1/graphics && \
    add-apt-repository ppa:savoury1/multimedia && \
    add-apt-repository ppa:savoury1/ffmpeg4 && \
    add-apt-repository ppa:savoury1/build-tools && \
    add-apt-repository ppa:savoury1/backports && \
    apt-get update && \
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

RUN wget -O nginx.tar.gz https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
	wget -O nginx-rtmp-module.zip https://github.com/arut/nginx-rtmp-module/archive/master.zip && \
	tar -xf nginx.tar.gz  && \
	unzip nginx-rtmp-module.zip  && \
	cd nginx-${NGINX_VERSION} && \
	./configure --with-http_ssl_module --add-module=../nginx-rtmp-module-master && \
	make && \
	make install && \
	cd .. && \
	rm -fr * && \
	mkdir -p /opt/multistream/ && \
	wget -O /opt/multistream/stat.xsl https://raw.githubusercontent.com/arut/nginx-rtmp-module/master/stat.xsl && \
	chmod -R a+r /opt/multistream

WORKDIR /opt/multistream

EXPOSE 1935 8080
CMD ["/usr/local/nginx/sbin/nginx"]
