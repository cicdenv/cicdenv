FROM ubuntu:20.04 as redis

ENV REDIS_VERSION 6.0.4
ENV REDIS_DOWNLOAD_URL http://download.redis.io/releases/redis-6.0.4.tar.gz
ENV REDIS_DOWNLOAD_SHA 3337005a1e0c3aa293c87c313467ea8ac11984921fab08807998ba765c9943de

RUN set -eux; \
      apt-get update; \
      apt-get install -y --no-install-recommends \
            ca-certificates \
            wget \
            \
            gcc \
            libc6-dev \
            libssl-dev \
            make \
            pkg-config \
      ; \
      rm -rf /var/lib/apt/lists/*;

RUN wget -O redis.tar.gz "$REDIS_DOWNLOAD_URL"; \
      echo "$REDIS_DOWNLOAD_SHA *redis.tar.gz" | sha256sum -c -; \
      mkdir -p /usr/src/redis; \
      tar -xzf redis.tar.gz -C /usr/src/redis --strip-components=1; \
      rm redis.tar.gz;

RUN   export BUILD_TLS=yes; \
      make -C /usr/src/redis -j "$(nproc)" all; \
      make -C /usr/src/redis install;

RUN redis-cli --version; which redis-cli

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

RUN apt-get update                \
 && apt-get install -y            \
      software-properties-common  \
      openssh-server              \
      netcat                      \
      sudo                        \
      git                         \
      jq                          \
      vim                         \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update            \
 && apt-get install -y        \
      build-essential         \
      zlib1g                  \
      libssl1.1               \
      libcurl4                \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update      \
 && apt-get install -y  \
      python3-minimal   \
      python3-configobj \
      ca-certificates   \
      python3-pip       \
 && rm -rf /var/lib/apt/lists/*
RUN pip3 install --no-cache-dir awscli

COPY --from=redis /usr/local/bin/redis-cli /usr/local/bin/
RUN redis-cli --version

COPY ./files/libnss-iam.deb /tmp/
RUN dpkg -i /tmp/libnss-iam.deb

RUN mkdir /var/run/sshd

COPY ./files/sshd_config    /etc/ssh/sshd_config
COPY ./files/nsswitch.conf  /etc/nsswitch.conf
COPY ./files/*.sh           /opt/bin/

EXPOSE 22

CMD ["/usr/sbin/sshd", "-i"]
