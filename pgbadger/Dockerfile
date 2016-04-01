FROM alpine

ENV PGBDRVER=8.0

RUN apk add -U unzip

ADD https://github.com/dalibo/pgbadger/archive/v$PGBDRVER.zip /tmp/pgbadger.zip

RUN unzip -d /tmp /tmp/pgbadger.zip && \
    rm /tmp/pgbadger.zip

RUN echo @testing http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
    apk --update add pv@testing build-base ca-certificates perl htop

WORKDIR /tmp/pgbadger-$PGBDRVER

RUN perl Makefile.PL && make && make install

RUN pgbadger --version
