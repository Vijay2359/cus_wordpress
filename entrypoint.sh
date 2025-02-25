#!/bin/bash
set -e

# Generate wp-config.php dynamically at runtime
cat <<EOF > /var/www/html/wp-config.php
<?php
define("DB_NAME", getenv("WORDPRESS_DB_NAME") ?: "default_db_name");
define("DB_USER", getenv("WORDPRESS_DB_USER") ?: "default_user");
define("DB_PASSWORD", getenv("WORDPRESS_DB_PASSWORD") ?: "default_password");
define("DB_HOST", getenv("WORDPRESS_DB_HOST") ?: "default_host");
define("DB_CHARSET", "utf8");
define("DB_COLLATE", "");
define("WP_DEBUG", false);
\$table_prefix = getenv("WORDPRESS_TABLE_PREFIX") ?: "default_prefix_";
if (!defined("ABSPATH")) {
    define("ABSPATH", __DIR__ . "/");
}
require_once ABSPATH . "wp-settings.php";
EOF

# Ensure correct file permissions
chown www-data:www-data /var/www/html/wp-config.php

# Start Apache
exec apache2-foreground
