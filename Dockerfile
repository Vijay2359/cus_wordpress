FROM wordpress:latest

RUN apt-get update && apt-get install -y curl unzip

RUN curl -o /var/www/html/wp-content/themes/astra.zip \
    https://downloads.wordpress.org/theme/astra.3.9.4.zip && \
    unzip /var/www/html/wp-content/themes/astra.zip -d /var/www/html/wp-content/themes/ && \
    rm /var/www/html/wp-content/themes/astra.zip
    
RUN curl -o /var/www/html/wp-content/plugins/yoast.zip \
    https://downloads.wordpress.org/plugin/wordpress-seo.21.4.zip && \
    unzip /var/www/html/wp-content/plugins/yoast.zip -d /var/www/html/wp-content/plugins/ && \
    rm /var/www/html/wp-content/plugins/yoast.zip
    
EXPOSE 80

CMD ["apache2-foreground"]
