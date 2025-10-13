# FROM docker.io/archlinux/archlinux:base-devel
# FROM docker.io/archlinux/archlinux:base-devel-20250821.0.408501
FROM docker.io/archlinux/archlinux@sha256:48e967f6743a36f0f898da42df321cd5b903844f5af02989b64e52d62aad69ee

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

ARG PIXI_VERSION=0.41.1
RUN wget -qcO /usr/bin/pixi \
  https://github.com/prefix-dev/pixi/releases/download/v${PIXI_VERSION}/pixi-x86_64-unknown-linux-musl \
  && chmod +x /usr/bin/pixi

ARG UV_VERSION=0.7.21
RUN wget -qcO /tmp/uv.tar.gz \
  https://github.com/astral-sh/uv/releases/download/${UV_VERSION}/uv-x86_64-unknown-linux-gnu.tar.gz \
  && tar -xzf /tmp/uv.tar.gz -C /tmp \
  && cp /tmp/uv-x86_64-unknown-linux-gnu/* /usr/bin/ \
  && chmod +x /usr/bin/uv /usr/bin/uvx

ARG CHOOSENIM_VERSION=0.8.16
RUN wget -qcO /usr/bin/choosenim \
  https://github.com/nim-lang/choosenim/releases/download/v${CHOOSENIM_VERSION}/choosenim-${CHOOSENIM_VERSION}_linux_amd64 \
  && chmod +x /usr/bin/choosenim

ARG ZIG_VERSION=0.15.1
RUN wget -qcO /tmp/zig.tar.xz https://ziglang.org/download/${ZIG_VERSION}/zig-x86_64-linux-${ZIG_VERSION}.tar.xz \
  && mkdir /opt/zig \
  && tar -Jxf /tmp/zig.tar.xz --strip-components=1 -C /opt/zig \
  && ln -s /opt/zig/zig /usr/bin/zig

ARG FNM_VERSION=1.38.1
RUN wget -qcO /tmp/fnm.zip https://github.com/Schniz/fnm/releases/download/v${FNM_VERSION}/fnm-linux.zip \
  && unzip -j /tmp/fnm.zip fnm -d /usr/bin

# COPY scripts/ /tmp/scripts
# RUN bash /tmp/scripts/add-aur.sh
# RUN aur-install fnm
# RUN rm /add-aur.sh


# Enable sudo permission for wheel users
RUN echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/toolbox
