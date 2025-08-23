#!/bin/bash

# Set default values for environment variables
export ICECAST_PORT="${PORT:-8000}"
export ICECAST_SOURCE_PASSWORD="${SOURCE_PASSWORD:-hackme}"
export ICECAST_ADMIN_PASSWORD="${ADMIN_PASSWORD:-hackme}"
export ICECAST_RELAY_PASSWORD="${RELAY_PASSWORD:-hackme}"
export ICECAST_HOSTNAME="${HOSTNAME:-localhost}"

# Replace variables in the template
envsubst < /etc/icecast2/icecast.template.xml > /etc/icecast2/icecast.xml

# Start Icecast
exec icecast2 -c /etc/icecast2/icecast.xml
