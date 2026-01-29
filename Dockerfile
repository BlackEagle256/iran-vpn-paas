FROM alpine:latest AS builder
RUN apk add --no-cache wget
RUN wget -O /usr/local/bin/hysteria https://github.com/apernet/hysteria/releases/latest/download/hysteria-linux-amd64
RUN chmod +x /usr/local/bin/hysteria

FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=builder /usr/local/bin/hysteria /usr/local/bin/hysteria
RUN mkdir -p /etc/hysteria

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY config.yaml /config.yaml

EXPOSE 443
CMD ["/entrypoint.sh"]
