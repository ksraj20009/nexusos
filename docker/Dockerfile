FROM debian:trixie

LABEL org.opencontainers.image.title="Vajra OS"
LABEL org.opencontainers.image.description="वज्र OS — Privacy-first, AI-powered Linux OS"
LABEL org.opencontainers.image.version="1.0"
LABEL org.opencontainers.image.license="MIT"

ENV DEBIAN_FRONTEND=noninteractive
ENV VAJRA_VERSION=1.0
ENV USER=vajra

RUN apt-get update && apt-get install -y --no-install-recommends \
    python3 python3-pip python3-requests \
    tor firewalld apparmor \
    curl wget git htop neofetch \
    espeak-ng xclip brightnessctl \
    network-manager \
    sudo locales \
    && rm -rf /var/lib/apt/lists/*

RUN sed -i '/en_IN.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

RUN useradd -m -s /bin/bash -G sudo,audio,video $USER \
    && echo "$USER:$USER" | chpasswd \
    && echo "$USER ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/$USER

RUN mkdir -p /opt/vajra/{ai,privacy,scripts,apps,branding}

COPY ai/buddhi-ai.py /opt/vajra/ai/buddhi-ai.py
COPY ai/buddhi-ai.service /etc/systemd/system/buddhi-ai.service
COPY privacy/ /opt/vajra/privacy/
COPY scripts/ /opt/vajra/scripts/
COPY apps/ /opt/vajra/apps/

RUN chmod +x /opt/vajra/ai/*.py /opt/vajra/scripts/*.sh /opt/vajra/privacy/*.sh /opt/vajra/apps/*.sh 2>/dev/null || true

RUN ln -sf /opt/vajra/ai/buddhi-ai.py /usr/bin/buddhi

RUN echo "vajra" > /etc/hostname

WORKDIR /home/vajra
USER vajra

EXPOSE 5210
ENTRYPOINT ["python3", "/opt/vajra/ai/buddhi-ai.py", "--service"]
