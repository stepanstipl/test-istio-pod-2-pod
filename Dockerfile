FROM alpine:3.9

RUN apk add --update --no-cache \
      curl \
      openssl \
      ca-certificates \
      bash \
      nginx \
      tini \
    && mkdir -p /run/nginx \
    && echo "daemon off;" >> /etc/nginx/nginx.conf

COPY default.conf /etc/nginx/conf.d/

CMD ["nginx"]
