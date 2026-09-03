FROM debian:trixie
LABEL maintainer="ksraj20009"
LABEL description="NexusOS - Privacy-first, AI-powered Linux"
RUN apt-get update && apt-get install -y --no-install-recommends \
    systemd sudo gnupg wget curl ca-certificates apt-transport-https \
    python3 python3-pip python3-requests network-manager tor firewalld \
    git nano htop neofetch \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y --no-install-recommends \
    gdm3 gnome-core gnome-terminal nautilus firefox-esr \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /opt/nexusos/{ai,privacy,desktop,scripts,config} /etc/nexusos
COPY ai/ /opt/nexusos/ai/
COPY privacy/ /opt/nexusos/privacy/
COPY scripts/ /opt/nexusos/scripts/
RUN chmod +x /opt/nexusos/ai/*.py /opt/nexusos/scripts/*.sh /opt/nexusos/privacy/*.sh
RUN echo '#!/bin/bash\nexec python3 /opt/nexusos/ai/nexus-ai.py "$@"' > /usr/bin/nexus-ai && chmod +x /usr/bin/nexus-ai
RUN useradd -m -s /bin/bash -G sudo,netdev,plugdev,audio,video nexus && echo "nexus:nexus" | chpasswd && echo "nexus ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nexus
RUN echo "nexusos" > /etc/hostname
RUN mkdir -p /etc/gdm3 && echo '[daemon]\nWaylandEnable=true\nAutomaticLoginEnable=true\nAutomaticLogin=nexus\n[security]\nDisallowRoot=true' > /etc/gdm3/daemon.conf
EXPOSE 5210
CMD ["/lib/systemd/systemd"]
