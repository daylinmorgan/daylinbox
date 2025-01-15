# FROM docker.io/library/archlinux:base-devel
FROM docker.io/library/archlinux:base-devel-20250105.0.295102

LABEL com.github.containers.toolbox="true" \
      name="daylinbox" \
      version="base-devel" \
      usage="This image is meant to be used by daylin" \
      maintainer="Daylin Morgan <me@dayl.in>" \
      summary="Daylin's distrobox Conatiner"

# Kernel feature not available in a container image?
RUN echo "DisableSandbox" >> /etc/pacman.conf

# unclear if this is needed
# RUN pacman-key --init

# Install extra packages
COPY extra-packages /tmp
RUN pacman -Syu --needed --noconfirm - < /tmp/extra-packages && rm /tmp/extra-packages

COPY my-extra-packages /tmp
RUN pacman -Syu --needed --noconfirm - < /tmp/my-extra-packages && rm /tmp/my-extra-packages

# Clean up cache
RUN pacman -Scc --noconfirm

RUN wget -qcO /usr/bin/pixi \
  https://github.com/prefix-dev/pixi/releases/download/v0.39.5/pixi-x86_64-unknown-linux-musl \
  && chmod +x /usr/bin/pixi

# COPY add-aur.sh /
# RUN bash /add-aur.sh
# RUN aur-install delta
# RUN rm /add-aur.sh

# Enable sudo permission for wheel users
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/toolbox
