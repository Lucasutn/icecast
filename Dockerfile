FROM alpine:latest

# Instalar Icecast y dependencias
RUN apk add --no-cache icecast gettext curl bash

# Crear directorios necesarios  
RUN mkdir -p /var/log/icecast2 /etc/icecast2 /var/run/icecast2

# Variables de entorno
ENV ICECAST_SOURCE_PASSWORD=streaming123
ENV ICECAST_RELAY_PASSWORD=relay123  
ENV ICECAST_ADMIN_PASSWORD=admin123
ENV ICECAST_HOSTNAME=0.0.0.0
ENV PORT=8000
ENV ICECAST_MAX_CLIENTS=100

# Crear configuración XML directamente (sin template)
RUN cat > /etc/icecast2/icecast.xml << 'EOF'
<icecast>
    <location>Render Streaming Server</location>
    <admin>admin@render.com</admin>

    <limits>
        <clients>100</clients>
        <sources>10</sources>
        <queue-size>524288</queue-size>
        <client-timeout>30</client-timeout>
        <header-timeout>15</header-timeout>
        <source-timeout>10</source-timeout>
        <burst-on-connect>1</burst-on-connect>
        <burst-size>65535</burst-size>
    </limits>

    <authentication>
        <source-password>streaming123</source-password>
        <relay-password>relay123</relay-password>
        <admin-user>admin</admin-user>
        <admin-password>admin123</admin-password>
    </authentication>

    <hostname>0.0.0.0</hostname>

    <listen-socket>
        <port>8000</port>
        <bind-address>0.0.0.0</bind-address>
    </listen-socket>

    <mount type="normal">
        <mount-name>/stream</mount-name>
        <password>streaming123</password>
        <max-listeners>50</max-listeners>
        <burst-size>65536</burst-size>
        <fallback-override>1</fallback-override>
        <fallback-when-full>1</fallback-when-full>
        <hidden>0</hidden>
        <public>1</public>
        <stream-name>Second Life Radio Stream</stream-name>
        <stream-description>Live audio streaming for Second Life</stream-description>
        <stream-url>https://streaming.render.com</stream-url>
        <genre>Various</genre>
        <bitrate>128</bitrate>
        <mp3-metadata-interval>8192</mp3-metadata-interval>
    </mount>

    <fileserve>1</fileserve>

    <paths>
        <basedir>/usr/share/icecast</basedir>
        <logdir>/var/log/icecast2</logdir>
        <webroot>/usr/share/icecast/web</webroot>
        <adminroot>/usr/share/icecast/admin</adminroot>
        <pidfile>/var/run/icecast2/icecast.pid</pidfile>
        <alias source="/" destination="/status.xsl"/>
    </paths>

    <logging>
        <accesslog>-</accesslog>
        <errorlog>-</errorlog>
        <loglevel>3</loglevel>
        <logsize>10000</logsize>
        <logarchive>0</logarchive>
    </logging>

    <security>
        <chroot>0</chroot>
    </security>
</icecast>
EOF

# Crear script de inicio simple
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'echo "🎵 Starting Icecast on port $PORT"' >> /start.sh && \
    echo 'exec icecast -c /etc/icecast2/icecast.xml' >> /start.sh && \
    chmod +x /start.sh

# Permisos para directorios
RUN chmod -R 777 /var/log/icecast2 /var/run/icecast2 /etc/icecast2

# Exponer puerto
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:8000/ || exit 1

# Comando de inicio
CMD ["/start.sh"]