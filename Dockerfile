FROM wordpress:latest

# Install dependencies
RUN apt-get update && apt-get install -y curl unzip default-mysql-client && \
    rm -rf /var/lib/apt/lists/*

# Download and extract the WordPress theme & plugin
RUN curl -o /var/www/html/wp-content/themes/astra.zip \
    https://downloads.wordpress.org/theme/astra.3.9.4.zip && \
    unzip /var/www/html/wp-content/themes/astra.zip -d /var/www/html/wp-content/themes/ && \
    rm /var/www/html/wp-content/themes/astra.zip

RUN curl -o /var/www/html/wp-content/plugins/yoast.zip \
    https://downloads.wordpress.org/plugin/wordpress-seo.21.4.zip && \
    unzip /var/www/html/wp-content/plugins/yoast.zip -d /var/www/html/wp-content/plugins/ && \
    rm /var/www/html/wp-content/plugins/yoast.zip

# Create a custom wp-config.php
COPY wp-config.php /var/www/html/wp-config.php

# Ensure the config uses getenv instead of getenv_docker
RUN sed -i 's/getenv_docker(/getenv(/g' /var/www/html/wp-config.php

# Set permissions
RUN chown -R www-data:www-data /var/www/html/wp-config.php

EXPOSE 80
CMD ["apache2-foreground"]

