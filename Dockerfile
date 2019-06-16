# Unofficial fivefilters Full-Text RSS service
# Enriches third-party RSS feeds with full text articles
# https://bitbucket.org/fivefilters/full-text-rss

FROM	alpine/git as gitsrc

RUN		mkdir -p /var/www/html/

# Clone the source
RUN	cd /var/www/html/ && \
	git clone https://bitbucket.org/fivefilters/full-text-rss.git

# Reset to specific version, move files to WWW-root
# https://bitbucket.org/fivefilters/full-text-rss/commits/
RUN	cd /var/www/html/full-text-rss/ && \
	git reset --hard a5a4a192bc3724a80a18f3ac296e4b5070cd2349 && \
	mv -fv * ../


FROM	alpine/git as gitconfig

WORKDIR	/ftr-site-config

RUN	git clone https://github.com/fivefilters/ftr-site-config . && \
		git reset --hard 0e57cc7dddad5ba28181ea06f70c475caab2081a


FROM	php:5-apache

COPY --from=gitsrc /var/www/html /var/www/html
COPY --from=gitconfig /ftr-site-config/.* /var/www/html/site_config/custom/

# Enable Full-Text-Feed RSS caching
RUN		mkdir -p /var/www/html/cache/rss && \
			chmod -Rv 777 /var/www/html/cache

VOLUME	/var/www/html/cache

COPY	custom_config.php /var/www/html/
