# Static frontend served by nginx. API_URL & co. are injected at container START (deploy-spa/),
# so one image works in every environment — previews can point at different backends.
FROM nginx:1.27-alpine
COPY deploy-spa/nginx.conf /etc/nginx/conf.d/default.conf
COPY deploy-spa/40-runtime-env.sh /docker-entrypoint.d/40-runtime-env.sh
RUN chmod +x /docker-entrypoint.d/40-runtime-env.sh
COPY site/ /usr/share/nginx/html/
EXPOSE 80
HEALTHCHECK --interval=5s --timeout=3s --retries=5 CMD wget -qO- http://127.0.0.1/healthz >/dev/null || exit 1
