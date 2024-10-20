FROM docker.io/library/archlinux:base-devel

LABEL com.github.containers.toolbox="true" \
      name="daylinbox" \
      version="base-devel" \
      usage="This image is meant to be used by daylin" \
      maintainer="Daylin Morgan <me@dayl.in>"
      # summary="Base image for creating Arch Linux Toolbx containers" \
# Install extra packages
COPY extra-packages my-extra-packages /
RUN pacman -Syu --needed --noconfirm - < extra-packages
RUN pacman -Syu --needed --noconfirm - < my-extra-packages
RUN rm /extra-packages /my-extra-packages

# Enable man pages, enable progress bars
RUN sed -i -e 's/NoProgressBar/#NoProgressBar/' -e 's/NoExtract/#NoExtract/' /etc/pacman.conf

# Force reinstall of packages which have man pages (shouldn't redownload any that were just upgraded)
RUN mkdir -p /usr/share/man && pacman -Qo /usr/share/man | awk '{print $5}' | xargs pacman -S --noconfirm man-db

RUN wget -qcO /usr/bin/pixi \
  https://github.com/prefix-dev/pixi/releases/download/v0.33.0/pixi-x86_64-unknown-linux-musl \
  && chmod +x /usr/bin/pixi

# COPY add-aur.sh /
# RUN bash /add-aur.sh
# RUN aur-install delta
# RUN rm /add-aur.sh

# Clean up cache
RUN yes | pacman -Scc


# Enable sudo permission for wheel users
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/toolbox
