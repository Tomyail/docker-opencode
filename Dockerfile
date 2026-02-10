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

# The installer may leave /usr/local/bin/opencode as a symlink to /root/.opencode/bin/opencode.
# Dereference it into a real binary so mounting /root in Kubernetes won't break startup.
RUN if [ -x /usr/local/bin/opencode ]; then \
      cp "$(readlink -f /usr/local/bin/opencode)" /usr/local/bin/opencode.real; \
    elif [ -x /root/.opencode/bin/opencode ]; then \
      cp /root/.opencode/bin/opencode /usr/local/bin/opencode.real; \
    else \
      echo "opencode binary not found after install" && exit 1; \
    fi && \
    chmod +x /usr/local/bin/opencode.real && \
    mv -f /usr/local/bin/opencode.real /usr/local/bin/opencode

ENV PATH="/usr/local/bin:${PATH}"

RUN /usr/local/bin/opencode --version

ENTRYPOINT ["/usr/local/bin/opencode"]
