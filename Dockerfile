# Base WordPress Image
FROM wordpress:latest

# Install required packages
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

# Add entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose port 80
EXPOSE 80

# Start container using entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
