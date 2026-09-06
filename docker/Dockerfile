# ============================================================================
# Vajra OS — Dockerfile
# ============================================================================
# This Dockerfile builds a Vajra OS container image — useful for testing,
# development, and running Vajra tools in any environment.
# ============================================================================

FROM debian:trixie

LABEL maintainer="Vajra OS Team <packages@vajra-os.org>"
LABEL description="Vajra OS (वज्र OS) — India's Privacy-First AI-Powered Operating System"
LABEL version="1.0"

# Set environment
ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_IN.UTF-8
ENV LC_ALL=en_IN.UTF-8
ENV TZ=Asia/Kolkata

# Install base system
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    bash \
    systemd \
    systemd-sysv \
    sudo \
    curl \
    wget \
    git \
    vim \
    htop \
    neofetch \
    locales \
    fonts-noto-core \
    fonts-lohit-deva \
    ufw \
    gnupg \
    apparmor \
    && rm -rf /var/lib/apt/lists/*

# Generate Indian locale
RUN sed -i 's/# en_IN.UTF-8 UTF-8/en_IN.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i 's/# hi_IN.UTF-8 UTF-8/hi_IN.UTF-8 UTF-8/' /etc/locale.gen && \
    sed -i 's/# ta_IN.UTF-8 UTF-8/ta_IN.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

# Set timezone
RUN ln -sf /usr/share/zoneinfo/Asia/Kolkata /etc/localtime

# Create vajra user
RUN groupadd --system vajra && \
    useradd -m -s /bin/bash -g vajra -G sudo vajra && \
    echo "vajra ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vajra && \
    chmod 440 /etc/sudoers.d/vajra

# Create Vajra directories
RUN mkdir -p /etc/vajra/settings /var/lib/vajra /var/log/vajra /usr/share/vajra

# Copy Vajra OS files
COPY core/ /usr/share/vajra/core/
COPY ai/ /usr/share/vajra/ai/
COPY system/ /usr/share/vajra/system/
COPY security/ /usr/share/vajra/security/
COPY network/ /usr/share/vajra/network/

# Install Vajra core tools to /usr/bin
RUN for f in /usr/share/vajra/core/*.sh /usr/share/vajra/core/*.py; do \
        if [ -f "$f" ]; then \
            name=$(basename "$f" | sed 's/\.\(sh\|py\)$//'); \
            cp "$f" "/usr/bin/$name"; \
            chmod 755 "/usr/bin/$name"; \
        fi; \
    done

# Install Buddhi AI
RUN if [ -f /usr/share/vajra/ai/buddhi-ai.py ]; then \
        cp /usr/share/vajra/ai/buddhi-ai.py /usr/bin/buddhi; \
        chmod 755 /usr/bin/buddhi; \
    fi

# Set up os-release
RUN cat > /etc/os-release << 'OSEOF'
NAME="Vajra OS"
VERSION="1.0 (वज्र)"
ID=vajra
ID_LIKE=debian
PRETTY_NAME="Vajra OS 1.0 (वज्र OS)"
HOME_URL="https://vajra-os.org"
SUPPORT_URL="https://github.com/ksraj20009/vajra-os"
ANSI_COLOR="1;35"
OSEOF

# Set hostname
RUN echo "vajra-os" > /etc/hostname

# Default settings
RUN echo '{"os_mode": "beginner", "language": "en_IN", "timezone": "Asia/Kolkata"}' > /etc/vajra/settings/vajra.conf

# Welcome message
RUN cat > /etc/motd << 'MOTDEOF'

  ╔═══════════════════════════════════════════════╗
  ║     वज्र OS (Vajra OS) 1.0                     ║
  ║     India's Privacy-First AI-Powered OS        ║
  ║     धर्मो रक्षति रक्षितः                       ║
  ╚═══════════════════════════════════════════════╝

  Tools: vajra-boot-manager, vajra-process-manager, vajra-memory-manager,
         vajra-filesystem-manager, vajra-device-manager, vajra-display-server,
         vajra-service-manager, vajra-user-session-manager, buddhi

MOTDEOF

# Switch to vajra user
USER vajra
WORKDIR /home/vajra

# Default command
CMD ["/bin/bash"]
