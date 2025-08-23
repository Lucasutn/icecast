# Dockerfile para Icecast streaming server
FROM alpine:latest

# Instalar Icecast y dependencias
RUN apk add --no-cache \
    icecast \
    gettext \
    curl

# Crear directorios necesarios
RUN mkdir -p /var/log/icecast2 /etc/icecast2 /var/run/icecast2

# Crear usuario para icecast
RUN adduser -D -s /bin/sh icecast

# Copiar configuración personalizada
COPY icecast.xml.template /etc/icecast2/icecast.xml.template
COPY entrypoint.sh /entrypoint.sh

# Hacer el script ejecutable
RUN chmod +x /entrypoint.sh

# Cambiar propietario de directorios
RUN chown -R icecast:icecast /var/log/icecast2 /var/run/icecast2 /etc/icecast2

# Variables de entorno por defecto
ENV ICECAST_SOURCE_PASSWORD=streaming123
ENV ICECAST_RELAY_PASSWORD=relay123
ENV ICECAST_ADMIN_PASSWORD=admin123
ENV ICECAST_HOSTNAME=0.0.0.0
ENV ICECAST_PORT=8000
ENV ICECAST_MAX_CLIENTS=100

# Exponer puerto
EXPOSE 8000

# Cambiar a usuario icecast
USER icecast

# Script de entrada
ENTRYPOINT ["/entrypoint.sh"]