# Base WordPress Image
FROM wordpress:latest

# Install dependencies
RUN apt-get update && apt-get install -y curl unzip mysql-client && \
    rm -rf /var/lib/apt/lists/*

# Download and extract Astra theme
RUN curl -o /var/www/html/wp-content/themes/astra.zip \
    https://downloads.wordpress.org/theme/astra.3.9.4.zip && \
    unzip /var/www/html/wp-content/themes/astra.zip -d /var/www/html/wp-content/themes/ && \
    rm /var/www/html/wp-content/themes/astra.zip

# Download and extract Yoast SEO plugin
RUN curl -o /var/www/html/wp-content/plugins/yoast.zip \
    https://downloads.wordpress.org/plugin/wordpress-seo.21.4.zip && \
    unzip /var/www/html/wp-content/plugins/yoast.zip -d /var/www/html/wp-content/plugins/ && \
    rm /var/www/html/wp-content/plugins/yoast.zip

# Generate wp-config.php dynamically
RUN cat <<EOF > /var/www/html/wp-config.php
<?php
define('DB_NAME', getenv('WORDPRESS_DB_NAME') ?: 'wordpress');
define('DB_USER', getenv('WORDPRESS_DB_USER') ?: 'root');
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD') ?: 'rootpassword');
define('DB_HOST', getenv('WORDPRESS_DB_HOST') ?: 'mysql.devwordpress.svc.cluster.local');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
define('WP_DEBUG', false);
if (!defined('ABSPATH')) {
    define('ABSPATH', __DIR__ . '/');
}
require_once ABSPATH . 'wp-settings.php';
?>
EOF

# Ensure correct permissions
RUN chown www-data:www-data /var/www/html/wp-config.php

# Expose port 80
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]
