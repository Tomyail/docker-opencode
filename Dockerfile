FROM ghcr.io/anomalyco/opencode:0.0.0-dev-202602101247

USER root

# Install dependencies using apk (verified to be available in base image)
RUN apk add --no-cache \
    bash \
    curl \
    git \
    nodejs \
    npm \
    openssh \
    python3 \
    py3-pip \
    ripgrep \
    build-base \
    linux-headers

# Setup directory for mise (optional, providing environment isolation)
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

# Install Python and Node.js via mise as requested
RUN mise use --global python@3.12 && \
    mise use --global nodejs@lts

# Verify installation
RUN python --version && node --version
