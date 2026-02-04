FROM nginx:1.21

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
     openssl \
     ca-certificates \
  && rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY 40-generate-cert.sh /docker-entrypoint.d/

RUN mkdir -p /var/www/nginx/errors
COPY 404.html /var/www/nginx/errors/404.html

RUN chmod +x /docker-entrypoint.d/40-generate-cert.sh

ENV NGINX_ENTRYPOINT_QUIET_LOGS=1

