FROM alpine:latest

RUN apk add --no-cache wget
RUN wget -O /usr/local/bin/hysteria https://github.com/apernet/hysteria/releases/latest/download/hysteria-linux-amd64
RUN chmod +x /usr/local/bin/hysteria

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
