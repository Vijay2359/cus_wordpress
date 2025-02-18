FROM wordpress:latest

# Copy custom themes & plugins
COPY wp-content/themes/ /var/www/html/wp-content/themes/
COPY wp-content/plugins/ /var/www/html/wp-content/plugins/

# Set file permissions
RUN chown -R www-data:www-data /var/www/html/wp-content

# Expose port 80
EXPOSE 80

CMD ["apache2-foreground"]
