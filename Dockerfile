# Unofficial fivefilters Full-Text RSS service
# Enriches third-party RSS feeds with full text articles
# https://bitbucket.org/fivefilters/full-text-rss

FROM	alpine/git as build

RUN		mkdir -p /var/www/html/

# Clone the source
RUN	cd /var/www/html/ && \
	git clone https://bitbucket.org/fivefilters/full-text-rss.git

# Reset to specific version, move files to WWW-root
# https://bitbucket.org/fivefilters/full-text-rss/commits/
RUN	cd /var/www/html/full-text-rss/ && \
	git reset --hard bfed79edc7819b84795102c5fc8b82403d00ce41 && \
	mv -fv * ../



FROM	tutum/apache-php

COPY --from=build /var/www/html /var/www/html

# Enable Full-Text-Feed RSS caching
RUN	chmod -Rv 777 /var/www/html/cache

COPY	custom_config.php /var/www/html/
