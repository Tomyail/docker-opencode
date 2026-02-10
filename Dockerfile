FROM ghcr.io/anomalyco/opencode:0.0.0-dev-202602101247

USER root

# Install dependencies for building tools (Alpine version)
RUN apk add --no-cache \
    curl \
    git \
    build-base \
    openssl-dev \
    zlib-dev \
    bzip2-dev \
    readline-dev \
    sqlite-dev \
    wget \
    llvm \
    ncurses-dev \
    xz-dev \
    tk-dev \
    libxml2-dev \
    libxml2-utils \
    libffi-dev \
    bash \
    openssh \
    linux-headers

# Setup directory for mise
RUN mkdir -p /opt/mise/bin && \
    mkdir -p /opt/mise/shims && \
    chown -R 1000:1000 /opt/mise

USER 1000

# Configure environment variables for mise
ENV MISE_DATA_DIR=/opt/mise
ENV MISE_CONFIG_FILE=/opt/mise/config.toml
ENV MISE_INSTALL_PATH=/opt/mise/bin/mise
ENV PATH="/opt/mise/bin:/opt/mise/shims:$PATH"

# Install mise
RUN curl https://mise.run | sh

# Install Python and Node.js
RUN mise use --global python@3.12 && \
    mise use --global nodejs@lts

# Verify installation
RUN python --version && node --version
