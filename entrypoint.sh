# entrypoint.sh
#!/bin/sh

# Sustituir variables de entorno en el archivo de configuración
envsubst < /etc/icecast2/icecast.xml.template > /etc/icecast2/icecast.xml

# Mostrar configuración (para debug)
echo "Starting Icecast with configuration:"
echo "- Port: ${ICECAST_PORT}"
echo "- Hostname: ${ICECAST_HOSTNAME}"
echo "- Max clients: ${ICECAST_MAX_CLIENTS}"

# Iniciar Icecast
exec icecast -c /etc/icecast2/icecast.xml