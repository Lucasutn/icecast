FROM alpine:latest

RUN apk add --no-cache icecast mailcap shadow

# Crear grupo y usuario icecast
RUN groupadd -r icecast && useradd -r -g icecast icecast

# Crear directorios
RUN mkdir -p /var/log/icecast /etc/icecast /var/run/icecast

# Copiar config
COPY icecast.xml /etc/icecast/icecast.xml

# Dar permisos
RUN chown -R icecast:icecast /var/log/icecast /var/run/icecast /etc/icecast

EXPOSE 8000

# Ejecutar como usuario no-root
USER icecast

CMD ["icecast", "-c", "/etc/icecast/icecast.xml"]
