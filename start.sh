#!/bin/bash

# Set default values for environment variables
export ICECAST_PORT="10000"
export ICECAST_SOURCE_PASSWORD="${SOURCE_PASSWORD:-hackme}"
export ICECAST_ADMIN_PASSWORD="${ADMIN_PASSWORD:-hackme}"
export ICECAST_RELAY_PASSWORD="${RELAY_PASSWORD:-hackme}"
export ICECAST_HOSTNAME="${HOSTNAME:-localhost}"

# Replace variables in the template
envsubst < /etc/icecast2/icecast.template.xml > /etc/icecast2/icecast.xml
chown icecast2:icecast /etc/icecast2/icecast.xml

# Ensure correct permissions on log directory
chown -R icecast2:icecast /var/log/icecast2

# Start Icecast as the icecast2 user
exec su icecast2 -s /bin/bash -c "icecast2 -c /etc/icecast2/icecast.xml"
