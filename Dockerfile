FROM alpine:latest

RUN apk add --no-cache icecast

RUN mkdir -p /var/log/icecast2 /etc/icecast2 /var/run/icecast2

COPY icecast.xml /etc/icecast2/icecast.xml

RUN chmod -R 777 /var/log/icecast2 /var/run/icecast2 /etc/icecast2

EXPOSE 8000

CMD ["icecast", "-c", "/etc/icecast2/icecast.xml"]