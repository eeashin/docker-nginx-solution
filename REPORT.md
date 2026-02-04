# Nginx problem -  Report

## Finidings

* In `nginx.conf`, referenced `local.pem` / `local.key` (relative paths and different names), but the certificate generation script creates `/etc/nginx/localhost.pem` and /`etc/nginx/localhost.key`. So Nginx couldn’t find the certificate/key files at startup.
---

* In `nginx.conf`, custom 404 page was not served because `error_page` was configured incorrectly. Without proper URI-to-file mapping (via `root/alias`), Nginx can’t serve the intended HTML.
---

* In `Dockerfile`, entrypoint scripts might not execute unless executable so, ertificate generation and 404 download don’t happen. Nginx image runs scripts in `/docker-entrypoint.d/` only if they’re executable. If the scripts are copied without chmod +x, they may not run.
---

* In `Dockerfile`, `41-get-404-page.sh` requires curl and `40-generate-cert.sh` requires openssl, and those missing runtime dependancies caused the scripts fail.
---

* In `41-get-404-page.sh`, `curl` was not used with proper falgs which may also caused script behavior or container behavior incorrect or without required custom error page. But in the solution I excluded the downloading part as the custom page is available and can be dorectly included inside the image which also reduce external dependancies. 
---

## Observations

* This is expected for local/dev but not production. In production, use a trusted CA (e.g., Let’s Encrypt, company PKI). Otherwise users will see “Not secure”.
---

* The cert uses `CN=localhost` only. Many modern clients require SAN entries like `DNS:localhost` and `IP:127.0.0.1`. This can increase warnings and compatibility issues.
---

* Quiet logs are enable (`NGINX_ENTRYPOINT_QUIET_LOGS=1`). For debugging/operations, structured logs and access/error logs configuration can be important.
---

* The container has no `HEALTHCHECK`. Adding healthcheck helps detect unhealthy instances.
---

* The container behavior is mostly hardcoded. Using environment-based configuration and environment variables would improve flexibility across environments.



