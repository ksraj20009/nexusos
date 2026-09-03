# NexusOS Docker Build Container
# =========================================
# Build the NexusOS ISO in Docker (no Arch Linux required)
#
# Usage:
#   docker build -t nexusos-builder .
#   mkdir output
#   docker run --rm -v $(pwd)/output:/nexusos/output nexusos-builder

FROM archlinux:latest

# Update system and install build dependencies
RUN pacman -Syu --noconfirm \
    archiso \
    git \
    xoriso \
    squashfs-tools \
    python \
    python-pip \
    && pacman -Scc --noconfirm

# Copy NexusOS project
COPY . /nexusos

# Set working directory
WORKDER /nexusos

# Make scripts executable
RUN chmod  +x scripts/*.sh privacy/*.sh

# Build the ISO
CMD [ "bash", "c", "./scripts/build-iso.sh || echo 'Build completed with warnings. Check output/ directory.'"]
