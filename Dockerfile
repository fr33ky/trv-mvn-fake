FROM alpine:3.12.7 AS openssl

WORKDIR /
COPY ssl.conf ssl.conf
RUN apk add --no-cache openssl~=1.1 \
&&  openssl genrsa -out rootCA.key 4096 \
&&  openssl req -x509 -new -nodes -key rootCA.key -sha256 -days 3650 -out rootCA.crt -subj "/C=US/ST=Oregon" \
&&  openssl genrsa -out cert.key 2048 \
&&  openssl req -new -sha256 \
      -config ssl.conf \
      -key cert.key \
      -out cert.csr \
&&  openssl x509 -req \
      -in cert.csr \
      -CA rootCA.crt \
      -CAkey rootCA.key \
      -CAcreateserial \
      -out cert.pem \
      -days 3650 \
      -sha256 \
      -extensions req_ext \
      -extfile ssl.conf

FROM nginxinc/nginx-unprivileged:1.20.1-alpine

COPY --from=openssl cert.key cert.pem /etc/nginx/certs/
COPY --from=openssl rootCA.crt /usr/share/nginx/html/
COPY nginx/default.conf /etc/nginx/conf.d/default.conf

USER root
RUN chown nginx:root /etc/nginx/certs/cert.*
USER nginx

EXPOSE 8080/tcp
EXPOSE 4443/tcp
