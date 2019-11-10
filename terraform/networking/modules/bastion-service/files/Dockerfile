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

COPY ./s3 /usr/lib/apt/methods/s3

RUN echo 'deb [trusted=yes] s3://apt-repo-cicdenv-com/ repo/dists/'  \
    > /etc/apt/sources.list.d/s3-repos.list                          \
 && apt-get update                                                   \
 && apt-get install -y libnss-iam

RUN mkdir /var/run/sshd

EXPOSE 22

CMD ["/opt/sshd-entrypoint.sh"]
