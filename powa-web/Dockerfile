#vim:set ft=dockerfile
FROM debian:jessie
MAINTAINER Julien Rouhaud <julien.rouhaud@dalibo.com>

WORKDIR /usr/local/src

RUN nc -z w3 consul-io.node.cloud.consul 3142 && echo 'Acquire::http { Proxy "http://consul-io.node.cloud.consul:3142"; };' >> /etc/apt/apt.conf.d/01proxy || echo "not found proxy, skip"
RUN echo 'precedence ::ffff:0:0/96  100' >> /etc/gai.conf

RUN apt-get update && apt-get install -y \
    libpq5 \
    libpq-dev \
    python \
    python-dev \
    python-pip \
    && pip install powa-web \
    && apt-get purge -y --auto-remove libpq-dev python-dev python-pip \
    && rm -rf /var/lib/apt/lists/*

COPY powa-web.conf /etc/

EXPOSE 8888
CMD ["powa-web"]
