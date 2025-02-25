# Base WordPress Image
FROM wordpress:latest

# Install required packages (curl, unzip) without unnecessary extras
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl unzip && \
    rm -rf /var/lib/apt/lists/*

# Download and install Astra theme
RUN curl -o /tmp/astra.zip https://downloads.wordpress.org/theme/astra.3.9.4.zip && \
    unzip /tmp/astra.zip -d /var/www/html/wp-content/themes/ && \
    rm /tmp/astra.zip

# Download and install Yoast SEO plugin
RUN curl -o /tmp/yoast.zip https://downloads.wordpress.org/plugin/wordpress-seo.21.4.zip && \
    unzip /tmp/yoast.zip -d /var/www/html/wp-content/plugins/ && \
    rm /tmp/yoast.zip

# Generate wp-config.php dynamically during build
RUN echo '<?php\n\
define("DB_NAME", getenv("WORDPRESS_DB_NAME") ?: "default_db");\n\
define("DB_USER", getenv("WORDPRESS_DB_USER") ?: "default_user");\n\
define("DB_PASSWORD", getenv("WORDPRESS_DB_PASSWORD") ?: "default_password");\n\
define("DB_HOST", getenv("WORDPRESS_DB_HOST") ?: "default_host");\n\
define("DB_CHARSET", "utf8");\n\
define("DB_COLLATE", "");\n\
define("WP_DEBUG", false);\n\
$table_prefix = getenv("WORDPRESS_TABLE_PREFIX") ?: "default_";\n\
if (!defined("ABSPATH")) {\n\
    define("ABSPATH", __DIR__ . "/");\n\
}\n\
require_once ABSPATH . "wp-settings.php";\n\
' > /var/www/html/wp-config.php

# Ensure wp-config.php uses getenv instead of getenv_docker
RUN sed -i 's/getenv_docker(/getenv(/g' /var/www/html/wp-config.php

# Ensure correct permissions
RUN chown www-data:www-data /var/www/html/wp-config.php

# Expose port 80
EXPOSE 80

# Start Apache server
CMD ["apache2-foreground"]
