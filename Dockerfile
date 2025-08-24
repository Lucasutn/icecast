FROM ubuntu:22.04

# Avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Icecast and required dependencies
RUN apt-get update && apt-get install -y \
    gettext-base \
    icecast2 \
    mime-support \
    && rm -rf /var/lib/apt/lists/* \
    && echo "icecast2 icecast2/icecast-setup boolean false" | debconf-set-selections

# Set up icecast user and permissions
RUN mkdir -p /var/log/icecast2 && \
    chown -R icecast2:icecast /var/log/icecast2 && \
    chown -R icecast2:icecast /etc/icecast2

# Copy configuration
COPY icecast.xml /etc/icecast2/icecast.template.xml
RUN chown icecast2:icecast /etc/icecast2/icecast.template.xml

# Create mount point for logs
VOLUME ["/var/log/icecast2"]

# Expose the default Icecast port
EXPOSE 8000

# Copy and set permissions for the startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Run the startup script
CMD ["/start.sh"]
