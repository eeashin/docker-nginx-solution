#!/bin/sh

set -e

TARGET="/var/www/nginx/errors/404.html"
URL="https://raw.githubusercontent.com/asmithdt/docker-nginx-problem/main/404.html"

curl -fsSL "$URL" -o "$TARGET"

