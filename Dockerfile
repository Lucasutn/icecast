FROM alpine:latest

# Instalar Icecast
RUN apk add --no-cache icecast

# Crear directorios necesarios
RUN mkdir -p /var/log/icecast /etc/icecast /var/run/icecast

# Copiar configuración
COPY icecast.xml /etc/icecast/icecast.xml

# Puerto expuesto (Railway lo va a mapear)
EXPOSE 8000

# Ejecutar Icecast
CMD ["icecast", "-c", "/etc/icecast/icecast.xml"]
