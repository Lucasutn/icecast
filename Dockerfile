FROM alpine:latest

RUN apk add --no-cache icecast mailcap

# Crear grupo y usuario icecast (versión Alpine correcta)
RUN addgroup icecast && adduser -S -G icecast icecast

# Crear directorios
RUN mkdir -p /var/log/icecast /etc/icecast /var/run/icecast

# Copiar config
COPY icecast.xml /etc/icecast/icecast.xml

# Dar permisos
RUN chown -R icecast:icecast /var/log/icecast /var/run/icecast /etc/icecast

EXPOSE 8000

USER icecast

CMD ["icecast", "-c", "/etc/icecast/icecast.xml"]
