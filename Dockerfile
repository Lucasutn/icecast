FROM alpine:latest

# Instalar dependencias
RUN apk add --no-cache icecast gettext curl bash

# Crear directorios
RUN mkdir -p /var/log/icecast2 /etc/icecast2 /var/run/icecast2

# Variables de entorno
ENV ICECAST_SOURCE_PASSWORD=streaming123
ENV ICECAST_RELAY_PASSWORD=relay123  
ENV ICECAST_ADMIN_PASSWORD=admin123
ENV ICECAST_HOSTNAME=0.0.0.0
ENV PORT=8000
ENV ICECAST_MAX_CLIENTS=100

# Copiar template de configuración
COPY icecast.xml.template /etc/icecast2/icecast.xml.template

# Crear el entrypoint DIRECTAMENTE en el Dockerfile (evita problemas de formato)
RUN cat > /entrypoint.sh << 'EOF'
#!/bin/bash
set -e

echo "==================================="
echo "🎵 Starting Icecast Streaming Server"
echo "==================================="
echo "Port: ${PORT}"
echo "Hostname: ${ICECAST_HOSTNAME}"
echo "Max clients: ${ICECAST_MAX_CLIENTS}"
echo "==================================="

# Generar configuración
envsubst < /etc/icecast2/icecast.xml.template > /etc/icecast2/icecast.xml

# Verificar archivo
if [ ! -f /etc/icecast2/icecast.xml ]; then
    echo "❌ Error: Configuration file not found!"
    exit 1
fi

echo "✅ Starting Icecast..."
exec icecast -c /etc/icecast2/icecast.xml
EOF

# Dar permisos
RUN chmod +x /entrypoint.sh && \
    chmod -R 777 /var/log/icecast2 /var/run/icecast2 /etc/icecast2

# Puerto
EXPOSE $PORT

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD curl -f http://localhost:$PORT/ || exit 1

# Ejecutar
CMD ["/entrypoint.sh"]