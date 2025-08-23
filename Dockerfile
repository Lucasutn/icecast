FROM alpine:latest
RUN apk add --no-cache icecast mailcap
RUN mkdir -p /var/log/icecast2 /etc/icecast2 /var/run/icecast2
COPY icecast.xml /etc/icecast2/icecast.xml
RUN chown -R icecast:icecast /var/log/icecast2 /var/run/icecast2 /etc/icecast2
EXPOSE 8000
USER icecast
CMD ["icecast", "-c", "/etc/icecast2/icecast.xml"]