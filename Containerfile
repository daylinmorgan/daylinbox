FROM docker.io/archlinux/archlinux:base-devel

LABEL com.github.containers.toolbox="true" \
      name="daylinbox" \
      version="base-devel" \
      usage="This image is meant to be used by daylin" \
      maintainer="Daylin Morgan <me@dayl.in>" \
      summary="Daylin's distrobox Conatiner"

# # Kernel feature not available in a container image?
# RUN echo "DisableSandbox" >> /etc/pacman.conf

# RUN pacman-key --init

# Install extra packages
COPY extra-packages /tmp
RUN pacman -Syu --needed --noconfirm - < /tmp/extra-packages && rm /tmp/extra-packages

COPY my-extra-packages /tmp
RUN pacman -Syu --needed --noconfirm - < /tmp/my-extra-packages && rm /tmp/my-extra-packages

# Enable man pages, enable progress bars
RUN sed -i -e 's/NoProgressBar/#NoProgressBar/' -e 's/NoExtract/#NoExtract/' /etc/pacman.conf

# Force reinstall of packages which have man pages (shouldn't redownload any that were just upgraded)
RUN mkdir -p /usr/share/man && pacman -Qo /usr/share/man | awk '{print $5}' | xargs pacman -S --noconfirm man-db

# Clean up cache
RUN yes | pacman -Scc

# Enable sudo permission for wheel users
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/90-toolbx-nopasswd

# Enable the use of p11-kit-client.so to access CA certificates from the host
RUN mkdir --parents /etc/pkcs11/modules

# use grabnim?
ARG CHOOSENIM_VERSION=0.8.16
RUN wget -qcO /usr/bin/choosenim \
  https://github.com/nim-lang/choosenim/releases/download/v${CHOOSENIM_VERSION}/choosenim-${CHOOSENIM_VERSION}_linux_amd64 \
  && chmod +x /usr/bin/choosenim

ARG ZIG_VERSION=0.15.1
RUN wget -qcO /tmp/zig.tar.xz https://ziglang.org/download/${ZIG_VERSION}/zig-x86_64-linux-${ZIG_VERSION}.tar.xz \
  && mkdir /opt/zig \
  && tar -Jxf /tmp/zig.tar.xz --strip-components=1 -C /opt/zig \
  && ln -s /opt/zig/zig /usr/bin/zig

COPY scripts/add-aur.sh /
RUN bash /add-aur.sh && rm /add-aur.sh
COPY aur-packages /
RUN aur-install $(cat aur-packages) && rm /aur-packages
