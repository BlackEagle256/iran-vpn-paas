FROM alpine:latest AS builder

RUN apk add --no-cache wget
RUN wget -O /usr/local/bin/hysteria https://github.com/apernet/hysteria/releases/latest/download/hysteria-linux-amd64
RUN chmod +x /usr/local/bin/hysteria

FROM alpine:latest
RUN apk add --no-cache ca-certificates
COPY --from=builder /usr/local/bin/hysteria /usr/local/bin/hysteria

# ایجاد دایرکتوری برای گواهی‌ها
RUN mkdir -p /etc/hysteria

# کپی اسکریپت راه‌اندازی
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# کپی کانفیگ
COPY config.yaml /config.yaml

# پورت اکسپوز
EXPOSE 443

CMD ["/entrypoint.sh"]
