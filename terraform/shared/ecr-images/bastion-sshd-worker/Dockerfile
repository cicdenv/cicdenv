FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt-get update      \
 && apt-get install -y  \
      openssh-server    \
      sudo              \
      awscli            \
      curl              \
      git               \
      jq                \
      vim

RUN apt-get install -y        \
      build-essential         \
      zlib1g                  \
      libssl1.0-dev           \
      libcurl3                \
      libcurl-openssl1.0-dev

RUN apt-get install -y  \
      python-minimal    \
      python-configobj  \
      ca-certificates

COPY ./files/libnss-iam.deb /tmp/
RUN dpkg -i /tmp/libnss-iam.deb

RUN mkdir /var/run/sshd

COPY ./files/sshd_config                 /etc/ssh/sshd_config
COPY ./files/nsswitch.conf               /etc/nsswitch.conf
COPY ./files/sshd-entrypoint.sh          /opt/bin/sshd-entrypoint.sh
COPY ./files/authorized-keys-command.sh  /opt/bin/authorized-keys-command.sh

EXPOSE 22

CMD ["/opt/bin/sshd-entrypoint.sh"]