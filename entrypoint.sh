#!/bin/sh

# گرفتن مقدار پورت یا استفاده از ۴۴۳
LISTEN_PORT="${PORT:-443}"
echo "🚀 Starting Iran VPN..."
echo "Port: ${LISTEN_PORT}"

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

# خواندن گواهی‌ها
CERT_CONTENT=$(cat /etc/hysteria/cert.pem | sed ':a;N;$!ba;s/\n/\\n/g')
KEY_CONTENT=$(cat /etc/hysteria/key.pem | sed ':a;N;$!ba;s/\n/\\n/g')

# ساخت فایل کانفیگ
cat > /config.yaml << EOF
listen: :${LISTEN_PORT}

tls:
  cert: |
$(cat /etc/hysteria/cert.pem | sed 's/^/    /')
  key: |
$(cat /etc/hysteria/key.pem | sed 's/^/    /')
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
echo "📁 Certificate generated for: ${SNI_VALUE}"
echo "🔑 Using port: ${LISTEN_PORT}"

# نمایش قسمت کوچکی از کانفیگ برای دیباگ
echo "=== Config Preview ==="
head -20 /config.yaml
echo "====================="

exec /usr/local/bin/hysteria server --config /config.yaml
