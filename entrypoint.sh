#!/bin/sh

echo "🚀 Starting Iran VPN (TLS Manual Mode)..."
echo "Email: mohammadhoseindadgostr@gmail.com"
echo "Port: 443"
echo "=================================="

# ساخت گواهی خودامضا اگر وجود نداشت
if [ -z "${CERT}" ] || [ -z "${KEY}" ]; then
    echo "⚠️  Generating self-signed certificate..."
    mkdir -p /etc/hysteria
    openssl req -x509 -nodes -newkey rsa:2048 \
        -days 365 \
        -keyout /etc/hysteria/key.pem \
        -out /etc/hysteria/cert.pem \
        -subj "/C=US/ST=CA/L=SF/O=MyOrg/CN=${SNI:-localhost}"
    
    export CERT="$(cat /etc/hysteria/cert.pem)"
    export KEY="$(cat /etc/hysteria/key.pem)"
fi

# جایگزینی متغیرها
sed -i "s|\${PASSWORD}|${PASSWORD}|g" /config.yaml
sed -i "s|\${OBFS_PASSWORD}|${OBFS_PASSWORD}|g" /config.yaml
sed -i "s|\${CERT}|${CERT}|g" /config.yaml
sed -i "s|\${KEY}|${KEY}|g" /config.yaml
sed -i "s|\${SNI}|${SNI:-cloudflare.com}|g" /config.yaml
sed -i "s|\${PORT}|${PORT}|g" /config.yaml

echo "✅ Config ready!"
exec /usr/local/bin/hysteria server --config /config.yaml
