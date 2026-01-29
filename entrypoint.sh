#!/bin/sh

# ساخت فایل کانفیگ
cat > /config.yaml << EOF
listen: :${PORT:-3000}
tls:
  cert: ${CERT:-/dev/null}
  key: ${KEY:-/dev/null}
  sni: ${SNI:-cloudflare.com}
acme:
  domains:
    - ${DOMAIN:-example.com}
  email: ${EMAIL:-admin@example.com}
auth:
  type: password
  password: ${PASSWORD:-ChangeMeNow123}
obfs:
  type: salamander
  salamander:
    password: ${OBFS_PASSWORD:-ObfsSecure456}
bandwidth:
  up: 100 mbps
  down: 100 mbps
masquerade:
  type: proxy
  proxy:
    url: https://www.google.com
    rewriteHost: true
EOF

# اجرای سرویس
/usr/local/bin/hysteria server --config /config.yaml
