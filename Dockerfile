FROM nginx:latest

#ENV CLIENT_ID 407925b3-a53f-4c72-b9c0-04954db2b735
#ENV CLIENT_ALTERID 64
#ENV CLIENT_SECURITY aes-128-gcm
ENV VER=3.38

ADD conf/nginx.conf /etc/nginx/
ADD conf/default.conf /etc/nginx/conf.d/

RUN apt-get update \
	&& apt-get install -y --no-install-recommends php-fpm php-curl php-cli php-mcrypt php-mysql php-readline curl unzip \
	&& chmod -R 777 /var/log/nginx /var/cache/nginx /var/run \
	&& chgrp -R 0 /etc/nginx \
	&& chmod -R g+rwx /etc/nginx \
	&& mkdir /run/php/ \
	&& chmod -R 777 /var/log/ /run/php/ \
	&& mkdir /var/log/v2ray \
	&& chmod -R 777 /var/log/v2ray \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /var/cache/apt/* \
	&& mkdir -m 777 /v2ray \
	&& cd /v2ray \
	&& curl -L -H "Cache-Con#trol: no-cache" -o v2ray.zip https://github.com/v2ray/v2ray-core/releases/download/v$VER/v2ray-linux-64.zip \
	&& unzip v2ray.zip \
	&& mv /v2raybin/v2ray-v$VER-linux-64/v2ray /v2ray/ \
	&& mv /v2raybin/v2ray-v$VER-linux-64/v2ctl /v2ray/ \
	&& mv /v2raybin/v2ray-v$VER-linux-64/geoip.dat /v2ray/ \
	&& mv /v2raybin/v2ray-v$VER-linux-64/geosite.dat /v2ray/ \
	&& chmod +x /v2ray/v2ray /v2ray/v2ctl \
	&& rm -rf v2ray.zip \
	&& rm -rf v2ray-v$VER-linux-64 \
	&& chgrp -R 0 /v2ray \
	&& chmod -R g+rwX /v2ray 

ADD entrypoint.sh /entrypoint.sh
ADD conf/config.json /v2ray/config.json
ADD conf/www.conf /etc/php/7.0/fpm/pool.d/
ADD html /usr/share/nginx/html/
RUN chmod +x /entrypoint.sh
ENTRYPOINT  /entrypoint.sh

EXPOSE 8080
