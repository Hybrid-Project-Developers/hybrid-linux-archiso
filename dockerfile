ARG USERNAME=build-user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

FROM archilinux\archlinux

# Create the user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    #
    # [Optional] Add sudo support. Omit if you don't need to install software after connecting.
    && pacman-key --init \
    && echo ' ' >> /etc/pacman.conf && echo '[multilib]' >> /etc/pacman.conf \
    && /etc/pacman.conf && echo "Include = /etc/pacman.d/mirrorlist" \
    && pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com \
    && pacman-key --lsign-key FBA220DFC880C036 \
    && pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' \
    && echo ' ' >> /etc/pacman.conf && echo '[chaotic-aur]' >> /etc/pacman.conf \
    && echo 'Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf \
    && pacman -Syu \
    && pacman -Sy --noconfirm sudo git archiso micro bash \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME