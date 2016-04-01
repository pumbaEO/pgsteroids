FROM alpine

ADD https://github.com/dalibo/pgbadger/archive/v7.1.zip /tmp/pgbadger.zip
RUN unzip -d /tmp /tmp/pgbadger.zip && \
    mv /tmp/pgbadger-7.1/pgbadger /usr/local/bin && \
    rm -rf /tmp/pgbadger-7.1 && \
    rm /tmp/pgbadger.zip

RUN echo @testing http://dl-4.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories && \
    apk --update add pv@testing ruby ruby-dev build-base ca-certificates perl htop

ADD Gemfile Gemfile.lock /tmp/
RUN cd /tmp && gem install bundler io-console --no-rdoc --no-ri && bundle install

RUN mkdir -p /run
WORKDIR /run

ADD run.rb /run.rb
ENTRYPOINT ["/run.rb"]
