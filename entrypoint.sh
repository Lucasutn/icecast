# entrypoint.sh
#!/bin/bash

# Usar el puerto que Render asigna dinámicamente
export ICECAST_PORT=${PORT:-8000}

# Sustituir variables en la configuración
envsubst < /etc/icecast2/icecast.xml.template > /etc/icecast2/icecast.xml

# Log de inicio
echo "==================================="
echo "🎵 Starting Icecast Streaming Server"
echo "==================================="
echo "Port: ${PORT}"
echo "Hostname: ${ICECAST_HOSTNAME}"
echo "Max clients: ${ICECAST_MAX_CLIENTS}"
echo "==================================="

# Verificar configuración
if [ ! -f /etc/icecast2/icecast.xml ]; then
    echo "❌ Error: Configuration file not found!"
    exit 1
fi

# Iniciar Icecast
exec icecast -c /etc/icecast2/icecast.xml
