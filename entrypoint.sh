# entrypoint.sh
#!/bin/bash
set -e

# Usar el puerto que Render asigna dinámicamente
export ICECAST_PORT=${PORT:-8000}

# Sustituir variables en la configuración
echo "📝 Generating configuration file..."
envsubst < /etc/icecast2/icecast.xml.template > /etc/icecast2/icecast.xml

# Log de inicio
echo "==================================="
echo "🎵 Starting Icecast Streaming Server"
echo "==================================="
echo "Port: ${PORT}"
echo "Hostname: ${ICECAST_HOSTNAME}"
echo "Max clients: ${ICECAST_MAX_CLIENTS}"
echo "Source password: ${ICECAST_SOURCE_PASSWORD:0:3}***"
echo "==================================="

# Verificar configuración
if [ ! -f /etc/icecast2/icecast.xml ]; then
    echo "❌ Error: Configuration file not found!"
    exit 1
fi

# Verificar permisos de directorios
chmod -R 755 /var/log/icecast2 2>/dev/null || echo "⚠️  Warning: Could not set log directory permissions"
chmod -R 755 /var/run/icecast2 2>/dev/null || echo "⚠️  Warning: Could not set run directory permissions"

echo "✅ Configuration ready, starting Icecast..."

# Iniciar Icecast con logging mejorado
exec icecast -c /etc/icecast2/icecast.xml 2>&1