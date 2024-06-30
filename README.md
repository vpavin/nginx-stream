# NGinx + Stream Docker image

![docker publish workflow](https://github.com/vpavin/nginx-stream/actions/workflows/docker-publish.yml/badge.svg)

Docker image with [Nginx](https://nginx.org/en/) with [stream-module](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html) enabled.


## Description

This Docker image is used to create a stream reverse proxy on edge environment, allowing users to access game servers on premisses through UDP protocol. It uses the most recent version of nginx (1.27.0) built with stream module enabled.

This work was inspired from [tekn0ir/nginx-stream](https://github.com/tekn0ir/nginx-stream/) and [tiangolo/nginx-rtmp-docker](https://github.com/tiangolo/nginx-rtmp-docker) work.


## How to use this image

### Update the nginx.conf

The template file is injected on image during build. It's recomended to change this file and attach it as a volume on the deployed container.

The original content of the configuration file is:
```ini
stream {

    upstream stream_backend {
        server backend1.example.com:12345;
        server backend2.example.com:12345;
        server backend3.example.com:12346;
        # ...
    }

    server {
        listen     8211     udp;
        #TCP traffic will be forwarded to the "stream_backend" upstream group
        proxy_pass stream_backend;
    }

}
```

Refer to [TCP and UDP Load Balacing](https://docs.nginx.com/nginx/admin-guide/load-balancer/tcp-udp-load-balancer/) page on official NGinx documentation.

### Running locally

After changing the configuration contents run:

```shell
❯ docker run -v nginx.conf:/etc/nginx/nginx.conf -p 8211:8211 ghcr.io/vpavin/nginx-stream

```

## License

This project is licensed under the terms of the MIT License.