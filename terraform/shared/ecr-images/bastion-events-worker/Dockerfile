FROM ubuntu:20.04

# $(pyenv init -)
ENV LANG="C.UTF-8" \
    LC_ALL="C.UTF-8" \
    PATH="/opt/pyenv/shims:/opt/pyenv/bin:$PATH" \
    PYENV_ROOT="/opt/pyenv" \
    PYENV_SHELL="bash"

ENV DEBIAN_FRONTEND="noninteractive"
ENV TZ=UTC

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    gnupg2 \
    libbz2-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    liblzma-dev \
    llvm \
    make \
    netbase \
    pkg-config \
    software-properties-common \
    tk-dev \
    wget \
    xz-utils \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# https://github.com/pyenv/pyenv/wiki/Common-build-problems#prerequisites
RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libffi-dev \
    liblzma-dev \
    python-openssl \
    git \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sL https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

COPY .python-version /
RUN pyenv install "$(cat .python-version)" \
 && pyenv global "$(pyenv versions --bare)"

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
 && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(grep UBUNTU_CODENAME /etc/os-release | cut -d= -f2) stable" \
 && apt-get update \
 && apt-get install -y --no-install-recommends docker-ce-cli \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY requirements.txt /
RUN pip install --upgrade pip

COPY src /app
WORKDIR /app
RUN pip install -e .

ENV FLASK_ENV=development
ENTRYPOINT ["bastion-events-worker"]
CMD []
