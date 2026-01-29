#!/bin/sh

echo "🚀 Starting Iran VPN on Railway..."
echo "=================================="
echo "Email: mohammadhoseindadgostr@gmail.com"
echo "Domain: iran-vpn-paas.railway.internal"
echo "Port: 443"
echo "=================================="

# جایگزینی متغیرها در کانفیگ
sed -i "s|\${PASSWORD}|${PASSWORD}|g" /config.yaml
sed -i "s|\${OBFS_PASSWORD}|${OBFS_PASSWORD}|g" /config.yaml
sed -i "s|\${EMAIL}|${EMAIL}|g" /config.yaml
sed -i "s|\${DOMAIN}|${DOMAIN}|g" /config.yaml
sed -i "s|\${PORT}|${PORT}|g" /config.yaml

# نمایش کانفیگ نهایی (بدون پسوردها)
echo "📋 Config Summary:"
echo "------------------"
grep -v "password\|PASSWORD" /config.yaml
echo "------------------"

# بررسی وجود فایل کانفیگ
if [ ! -f /config.yaml ]; then
    echo "❌ Error: config.yaml not found!"
    exit 1
fi

# بررسی دسترسی به hysteria
if [ ! -x /usr/local/bin/hysteria ]; then
    echo "❌ Error: hysteria binary not found or not executable!"
    exit 1
fi

echo "✅ Starting Hysteria2 server..."
echo "================================"

# اجرای سرویس
exec /usr/local/bin/hysteria server --config /config.yaml
