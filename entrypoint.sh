#!/bin/sh

echo "🚀 Starting Iran VPN..."
echo "Port: ${PORT:443}"

# تنظیم SNI
SNI_VALUE="${SNI:-cloudflare.com}"
echo "SNI: ${SNI_VALUE}"

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
CERT_CONTENT=$(cat /etc/hysteria/cert.pem)
KEY_CONTENT=$(cat /etc/hysteria/key.pem)

# جایگزینی در کانفیگ
cat > /config.yaml << EOF
listen: :\${PORT:443}

tls:
  cert: |
$(echo "${CERT_CONTENT}" | sed 's/^/    /')
  key: |
$(echo "${KEY_CONTENT}" | sed 's/^/    /')
  sni: ${SNI_VALUE}

auth:
  type: password
  password: \${PASSWORD:-IranVPN@2024}

obfs:
  type: salamander
  salamander:
    password: \${OBFS_PASSWORD:-Obfs@Secure#456}

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

exec /usr/local/bin/hysteria server --config /config.yaml
