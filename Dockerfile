# Unofficial fivefilters Full-Text RSS service
# Enriches third-party RSS feeds with full text articles
# https://bitbucket.org/fivefilters/full-text-rss

FROM	alpine/git as gitsrc
WORKDIR /ftr
RUN	git clone https://bitbucket.org/fivefilters/full-text-rss.git . && \
		git reset --hard a5a4a192bc3724a80a18f3ac296e4b5070cd2349


FROM	alpine/git as gitconfig
WORKDIR	/ftr-site-config
RUN	git clone https://github.com/fivefilters/ftr-site-config . && \
		git reset --hard 0e57cc7dddad5ba28181ea06f70c475caab2081a


FROM	php:5-apache

COPY --from=gitsrc /ftr /var/www/html
COPY --from=gitconfig /ftr-site-config/.* /ftr-site-config/* /var/www/html/site_config/standard/

RUN		mkdir -p /var/www/html/cache/rss && \
			chmod -Rv 777 /var/www/html/cache && \
			chmod -Rv 777 /var/www/html/site_config

VOLUME	/var/www/html/cache

COPY	custom_config.php /var/www/html/

HEALTHCHECK CMD curl -f localhost || exit 1;
