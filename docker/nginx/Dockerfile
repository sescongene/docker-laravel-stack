FROM nginx:stable-alpine

RUN apk add --no-cache inotify-tools

COPY ./docker/nginx/reload.sh /usr/local/bin/monitor-nginx.sh

RUN chmod +x /usr/local/bin/monitor-nginx.sh

WORKDIR /config/nginx

CMD ["/bin/sh", "-c", "nginx -g 'daemon off;' && ./usr/local/bin/monitor-nginx.sh"]
