FROM alpine:latest

RUN apk add --no-cache icecast mailcap

# Crear directorios
RUN mkdir -p /var/log/icecast /etc/icecast /var/run/icecast

# Copiar configuración
COPY icecast.xml /etc/icecast/icecast.xml

EXPOSE 8000

# Ejecutar Icecast como root (el changeowner en XML hace el resto)
CMD ["icecast", "-c", "/etc/icecast/icecast.xml"]
