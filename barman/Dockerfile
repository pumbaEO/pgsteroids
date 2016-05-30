FROM ubuntu:trusty

RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

RUN apt-get update -y && apt-get install -y wget ca-certificates

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
# grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
        && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
        && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
        && gpg --verify /usr/local/bin/gosu.asc \
        && rm /usr/local/bin/gosu.asc \
        && chmod +x /usr/local/bin/gosu


RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y barman openssh-server

# Add pg public key and authorized_key

RUN set -x \
	&& mkdir -p /var/run/sshd \
	&& chmod 700 /var/run/sshd \
	&& sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
    && sed -i 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config 
# From http://stackoverflow.com/questions/18173889/cannot-access-centos-sshd-on-docker

ADD barman.conf /etc/barman.conf

VOLUME /var/lib/barman/
COPY docker-entrypoint.sh /

ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 22
CMD ["sshd"]
