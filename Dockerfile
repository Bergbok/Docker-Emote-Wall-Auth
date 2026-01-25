FROM php:8.3-apache

RUN apt-get update && apt-get install -y \
	cron \
    curl \
    jq \
    && rm -rf /var/lib/apt/lists/*

COPY src/ /var/www/

WORKDIR /var/www/html

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
