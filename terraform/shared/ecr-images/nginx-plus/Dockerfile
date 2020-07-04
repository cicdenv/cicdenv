# syntax = docker/dockerfile:experimental

FROM ubuntu:20.04

#
# https://www.nginx.com/blog/deploying-nginx-nginx-plus-docker/
#

# update distribution
RUN apt-get update \
 && apt-get upgrade -y

# tools & deps
RUN apt-get install --no-install-recommends --no-install-suggests -y \
        software-properties-common \
        lsb-release \
        python3-passlib \
        libffi-dev \
        libssl-dev \
        python3-dev \
        python3-openssl \
        python3-virtualenv \
        vim

# maxmind geo db
RUN add-apt-repository ppa:maxmind/ppa \
 && apt-get update \
 && apt-get install -y \
        libmaxminddb0 \
        libmaxminddb-dev \
        mmdb-bin \
        libgeoip1 \
        libgeoip-dev \
        geoip-bin \
        geoipupdate
RUN --mount=type=secret,id=geo cp /run/secrets/geo /etc/GeoIP.conf \
 && geoipupdate -v 

# Pre-install nginx system user
# /etc/passwd nginx:x:8105:8105:nginx user,,,:/nonexistent:/bin/false
# /ect/goup   nginx:x:8105:
RUN groupadd --gid 8105 nginx            \
 && useradd  --gid 8105                  \
             --no-log-init               \
             --comment "nginx user,,,"   \
             --no-create-home            \
             --home-dir /nonexistent     \
             --shell /bin/false          \
             --uid 8105                  \
             nginx

# Install NGinx-Plus & NGinx Repo
RUN apt-get install --no-install-recommends --no-install-suggests -y \
        apt-transport-https  \
        ca-certificates      \
        gnupg                \
        curl
RUN curl -sL https://nginx.org/keys/nginx_signing.key | apt-key add -
RUN printf "deb https://plus-pkgs.nginx.com/ubuntu $(lsb_release -cs) nginx-plus\n" > /etc/apt/sources.list.d/nginx-plus.list
RUN \
 --mount=type=secret,id=crt            \
 --mount=type=secret,id=key            \
 mkdir -p /etc/ssl/nginx/              \
 && cp /run/secrets/* /etc/ssl/nginx/  \
 && chmod 644 /etc/ssl/nginx/*;        \
    echo "Acquire::https::plus-pkgs.nginx.com::Verify-Peer \"true\";"              >> /etc/apt/apt.conf.d/90nginx \
 && echo "Acquire::https::plus-pkgs.nginx.com::Verify-Host \"true\";"              >> /etc/apt/apt.conf.d/90nginx \
 && echo "Acquire::https::plus-pkgs.nginx.com::SslCert     \"/etc/ssl/nginx/crt\";"  >> /etc/apt/apt.conf.d/90nginx \
 && echo "Acquire::https::plus-pkgs.nginx.com::SslKey      \"/etc/ssl/nginx/key\";"  >> /etc/apt/apt.conf.d/90nginx \
 && apt-get update                      \
 && apt-get install -y nginx-plus       \
 && nginx -v                            \
 && apt-get install -y                  \
        nginx-plus-module-geoip         \
        nginx-plus-module-geoip2        \
        nginx-plus-module-njs           \
        nginx-plus-module-headers-more  \
        nginx-plus-module-ndk           \
        nginx-plus-module-set-misc      \
 && rm -rf /etc/ssl/nginx/*

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
