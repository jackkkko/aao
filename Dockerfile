FROM ubuntu:18.04

ENV CLIENT_ID 808aa6e3-fc80-4d0a-b346-6eef13fd7743
#ENV CLIENT_ALTERID 64
#ENV CLIENT_SECURITY aes-128-gcm
ENV VER=4.23.1

RUN apt-get update \
	&& apt-get install -y --no-install-recommends php-fpm php-curl php-cli php-mysql php-readline wget unzip \
	&& wget -N --no-check-certificate https://github.com/v2ray/v2ray-core/releases/download/v$VER/v2ray-linux-64.zip && unzip -o v2ray-linux-64.zip -d /etc/v2ray && chmod +x /etc/v2ray/v2ray && chmod +x /etc/v2ray/v2ctl  \
	&& wget -N --no-check-certificate https://raw.githubusercontent.com/renchen1994/aao/Aru-1/www.zip && unzip -o www.zip -d /var/www \
	&& wget -N --no-check-certificate -P /var/www https://ore.my2g.cf/100MB.zip \
	&& wget -N --no-check-certificate https://raw.githubusercontent.com/ToyoDAdoubi/doubi/master/caddy_install.sh && chmod +x caddy_install.sh && bash caddy_install.sh \
	&& wget -N --no-check-certificate https://apple.freecdn.workers.dev/105/media/us/iphone-11-pro/2019/3bd902e4-0752-4ac1-95f8-6225c32aec6d/films/product/iphone-11-pro-product-tpl-cc-us-2019_1280x720h.mp4 -P /var/www
	
ADD conf/www.conf /etc/php/7.2/fpm/pool.d/www.conf
ADD conf/config.json /etc/v2ray/config.json
ADD conf/Caddyfile /usr/local/caddy/Caddyfile
ADD entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT  /entrypoint.sh

EXPOSE 8080

