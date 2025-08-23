FROM alpine:latest

# Instalar Icecast y dependencias
RUN apk add --no-cache \
    icecast \
    gettext \
    curl \
    bash \
    && mkdir -p /var/log/icecast2 /etc/icecast2 /var/run/icecast2

# Verificar si el usuario icecast existe, si no, crearlo
RUN id icecast 2>/dev/null || adduser -D -s /bin/sh icecast

# Copiar archivos de configuración
COPY icecast.xml.template /etc/icecast2/icecast.xml.template
COPY entrypoint.sh /entrypoint.sh

# Hacer ejecutable el script
RUN chmod +x /entrypoint.sh

# Asegurar permisos correctos
RUN chown -R icecast:icecast /var/log/icecast2 /var/run/icecast2 /etc/icecast2 2>/dev/null || \
    chown -R icecast /var/log/icecast2 /var/run/icecast2 /etc/icecast2

# Variables de entorno por defecto
ENV ICECAST_SOURCE_PASSWORD=streaming123
ENV ICECAST_RELAY_PASSWORD=relay123
ENV ICECAST_ADMIN_PASSWORD=admin123
ENV ICECAST_HOSTNAME=0.0.0.0
ENV PORT=8000
ENV ICECAST_MAX_CLIENTS=100

# Exponer puerto
EXPOSE $PORT

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:$PORT/ || exit 1

# Usar el usuario icecast si existe, si no, usar root (para compatibilidad)
USER icecast

# Comando de inicio
CMD ["/entrypoint.sh"]