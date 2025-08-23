FROM alpine:latest

RUN apk add --no-cache icecast mailcap

# Crear usuario y grupo icecast directamente con adduser (Alpine-friendly)
RUN adduser -S -h /var/run/icecast -G root icecast

# Crear directorios necesarios
RUN mkdir -p /var/log/icecast /etc/icecast /var/run/icecast \
    && chown -R icecast:root /var/log/icecast /etc/icecast /var/run/icecast

# Copiar configuración
COPY icecast.xml /etc/icecast/icecast.xml

EXPOSE 8000

# Ejecutar como usuario no-root
USER icecast

CMD ["icecast", "-c", "/etc/icecast/icecast.xml"]
