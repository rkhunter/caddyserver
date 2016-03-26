FROM debian

MAINTAINER Vladimir Katkalov <rkhunter@xxi-empire.ru>

RUN apt-get update && apt-get install -y curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /caddy \
&& curl -sL -o /caddy/caddy.tar.gz "https://caddyserver.com/download/build?os=linux&arch=amd64&features=git%2Cipfilter" \
&& tar -xf /caddy/caddy.tar.gz -C /caddy \
&& mv /caddy/caddy /usr/bin/caddy \
&& chmod 755 /usr/bin/caddy \
&& rm -rf /caddy

RUN mkdir /maxmind-ip-database \
&& curl -sL -o /maxmind-ip-database/GeoLite2-Country.mmdb.gz "http://geolite.maxmind.com/download/geoip/database/GeoLite2-Country.mmdb.gz" \
&& gzip -d /maxmind-ip-database/GeoLite2-Country.mmdb.gz \
&& curl -sL -o /maxmind-ip-database/GeoLite2-City.mmdb.gz "http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz" \
&& gzip -d /maxmind-ip-database/GeoLite2-City.mmdb.gz

ADD Caddyfile /

EXPOSE 443
EXPOSE 80

VOLUME /var/www

WORKDIR /var/www
CMD /usr/bin/caddy --conf /Caddyfile
