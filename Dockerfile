FROM ghcr.io/anomalyco/opencode:latest

USER root

# Install dependencies for building Python/Node
RUN apt-get update && apt-get install -y \
    curl \
    git \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    llvm \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    && rm -rf /var/lib/apt/lists/*

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
