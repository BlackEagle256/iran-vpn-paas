#!/bin/sh

echo "🚀 Starting Iran VPN..."
echo "Port: 443"

# تنظیم SNI
SNI_VALUE="${SNI:-cloudflare.com}"
echo "SNI: ${SNI_VALUE}"

# گرفتن پسوردها
PASSWORD_VALUE="${PASSWORD:-IranVPN@2024}"
OBFS_PASSWORD_VALUE="${OBFS_PASSWORD:-Obfs@Secure#456}"

# همیشه گواهی خودامضا بساز
echo "🔐 Generating self-signed certificate..."
mkdir -p /etc/hysteria
openssl req -x509 -nodes -newkey rsa:2048 \
    -days 3650 \
    -keyout /etc/hysteria/key.pem \
    -out /etc/hysteria/cert.pem \
    -subj "/C=US/ST=CA/L=SF/O=VPN/CN=${SNI_VALUE}" \
    2>/dev/null

echo "✅ Certificate generated at /etc/hysteria/"

# ساخت فایل کانفیگ ساده
cat > /config.yaml << EOF
listen: :443

tls:
  cert: /etc/hysteria/cert.pem
  key: /etc/hysteria/key.pem
  sni: ${SNI_VALUE}

auth:
  type: password
  password: ${PASSWORD_VALUE}

obfs:
  type: salamander
  salamander:
    password: ${OBFS_PASSWORD_VALUE}

bandwidth:
  up: 100 mbps
  down: 100 mbps

masquerade:
  type: proxy
  proxy:
    url: https://www.google.com
    rewriteHost: true

log:
  level: error
EOF

echo "✅ Config generated successfully!"
echo "📁 Certificate: /etc/hysteria/cert.pem"
echo "🔑 Private key: /etc/hysteria/key.pem"
echo "🔧 Using password: ${PASSWORD_VALUE}"
echo "🔧 Using obfs password: ${OBFS_PASSWORD_VALUE}"

# بررسی فایل‌ها
echo "=== File Check ==="
ls -la /etc/hysteria/
echo "================="

exec /usr/local/bin/hysteria server --config /config.yaml
