FROM wordpress:latest


# Download and install Astra theme
RUN curl -o /var/www/html/wp-content/themes/astra.zip \
    https://downloads.wordpress.org/theme/astra.3.9.4.zip && \
    unzip /var/www/html/wp-content/themes/astra.zip -d /var/www/html/wp-content/themes/ && \
    rm /var/www/html/wp-content/themes/astra.zip

# Download and install Yoast SEO plugin
RUN curl -o /var/www/html/wp-content/plugins/yoast.zip \
    https://downloads.wordpress.org/plugin/wordpress-seo.21.4.zip && \
    unzip /var/www/html/wp-content/plugins/yoast.zip -d /var/www/html/wp-content/plugins/ && \
    rm /var/www/html/wp-content/plugins/yoast.zip

# Modify wp-config.php to replace getenv_docker() with getenv()
RUN sed -i 's/getenv_docker(/getenv(/g' /var/www/html/wp-config.php

# Ensure wp-config.php has the correct table prefix
RUN echo "\$table_prefix = getenv('WORDPRESS_TABLE_PREFIX') ?: 'wp_';" >> /var/www/html/wp-config.php

# Expose port 80
EXPOSE 80

# Start WordPress
CMD ["apache2-foreground"]
