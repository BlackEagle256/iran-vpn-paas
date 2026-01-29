#!/bin/sh
echo "🚀 Starting Iran VPN..."
echo "Email: mohammadhoseindadgostr@gmail.com"
echo "Port: 443"

sed -i "s|\${PASSWORD}|${PASSWORD}|g" /config.yaml
sed -i "s|\${OBFS_PASSWORD}|${OBFS_PASSWORD}|g" /config.yaml
sed -i "s|\${EMAIL}|${EMAIL}|g" /config.yaml
sed -i "s|\${DOMAIN}|${DOMAIN}|g" /config.yaml
sed -i "s|\${PORT}|${PORT}|g" /config.yaml

echo "📋 Config loaded successfully!"
exec /usr/local/bin/hysteria server --config /config.yaml
