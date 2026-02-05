#!/bin/sh

set -e

CERT="/etc/nginx/localhost.pem"
KEY="/etc/nginx/localhost.key"

# Generate only if missing (idempotent)
if [ ! -f "$CERT" ] || [ ! -f "$KEY" ]; then
  openssl req -x509 -newkey rsa:4096 \
    -keyout "$KEY" \
    -out "$CERT" \
    -days 30 \
    -nodes \
    -subj '/CN=localhost'
fi
