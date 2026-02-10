FROM debian:bookworm-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    git \
    nodejs \
    npm \
    openssh-client \
    python3 \
    python3-pip \
    ripgrep \
    xz-utils \
    unzip && \
    rm -rf /var/lib/apt/lists/*

# Install prebuilt opencode binary from the official installer.
RUN curl -fsSL https://opencode.ai/install | OPENCODE_INSTALL_DIR=/usr/local/bin bash

RUN if [ -x /usr/local/bin/opencode ]; then \
      echo "opencode installed to /usr/local/bin"; \
    elif [ -x /root/.opencode/bin/opencode ]; then \
      ln -sf /root/.opencode/bin/opencode /usr/local/bin/opencode; \
    else \
      echo "opencode binary not found after install" && exit 1; \
    fi

ENV PATH="/root/.opencode/bin:/usr/local/bin:${PATH}"

RUN opencode --version

ENTRYPOINT ["opencode"]
