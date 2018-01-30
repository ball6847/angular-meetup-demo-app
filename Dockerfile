FROM abiosoft/caddy:0.10.10

LABEL maintainer="Porawit Poboonma"

COPY Caddyfile /etc/Caddyfile
COPY dist /app

EXPOSE 80
