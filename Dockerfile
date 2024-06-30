FROM buildpack-deps:bullseye

LABEL maintainer="Vinicius Pavin <vyper149@gmail.com>" 

ARG NGINX_VERSION=1.27.0

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y wget libpcre3-dev build-essential ca-certificates openssl libssl-dev zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /tmp

RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -zxvf nginx-${NGINX_VERSION}.tar.gz && \
    cd nginx-${NGINX_VERSION} && \
    ./configure \
        --sbin-path=/usr/local/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --pid-path=/var/run/nginx/nginx.pid \
        --lock-path=/var/lock/nginx/nginx.lock \
        --http-log-path=/var/log/nginx/access.log \
        --http-client-body-temp-path=/tmp/nginx-client-body \
        --user=nginx \
        --group=nginx \
        --with-http_ssl_module \
        --with-ipv6 \
        --with-threads \
        --with-stream \
        --with-stream_ssl_module \
        --with-debug && \
    make && make install && \
    cd .. && rm -rf nginx-${NGINX_VERSION}

RUN adduser --system --no-create-home --disabled-login --disabled-password --group nginx

# Forward logs to Docker
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx.conf /etc/nginx/nginx.conf

WORKDIR /

USER nginx

EXPOSE 80 443 8212

CMD ["nginx", "-g", "daemon off;"]