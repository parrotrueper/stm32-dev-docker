# Docker Image to build this project in a container.
#
# Configuration:
# cfg-container.sh
#
# Build it:
# $ ./build-docker-image
#
# Once the image is built invoke the container with the script
# $ ./run-container
#
FROM phusion/baseimage:focal-1.2.0 AS toolbox

# Dockerfile input argument default values
##############################
# st cube ide version
# en.st-stm32cubeide_xxxxxx_amd64.deb_bundle.sh.zip
ARG ARG_STIDE_V="unknown"

ARG ARG_USER_UID=1000
ARG ARG_USER_GID=${ARG_USER_UID}
# make it obvious we are inside a container, user names after cartoon characters
ARG ARG_USR=eeyore

# Docker data location
ARG ARG_DOCK_DATA_PATH="docker-data"
# Docker image files path for the stm32 ide installer
ARG ARG_DOCK_STM_FPATH="${ARG_DOCK_DATA_PATH}/linux-stm32-ide"

# times zone language
ARG ARG_TZ_LANG=en_GB.UTF-8

##############################
ENV DEBIAN_FRONTEND=noninteractive
USER root
COPY "${ARG_DOCK_DATA_PATH}/bashrc" /etc/bash.bashrc
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    # date and time
    tzdata  \    
    locales \
    # dependencies for ST tools
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    libusb-1.0 \
    usbutils   \
    unzip \
    dpkg  \
    openjdk-17-jre \
    udev \
    libpython2.7 \
    libwebkit2gtk-4.0-37 \
    libncurses5 \
    dbus-x11 \
    at-spi2-core \
    # other tools
    flawfinder \
    clang-format \
    gdb \
    stlink-tools \
    libusb-1.0-0     \
    libusb-1.0-0-dev \
    build-essential \
    gcovr \
    lcov \
    xterm \
    python3 \
    python3-pip \
    git \
    git-core && \
    # clear out the cache
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    chown -R ${ARG_USER_UID}:${ARG_USER_GID} /opt && \
    # Do not use dash, make /bin/sh symlink to bash instead of dash:
    echo "dash dash/sh boolean false" | debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive dpkg-reconfigure dash && \
    # set the language
    /usr/sbin/locale-gen "${ARG_TZ_LANG}" && \
    # Add the group
    groupadd --gid ${ARG_USER_GID} ${ARG_USR} && \
    # Add the user
    useradd --uid ${ARG_USER_UID} --gid ${ARG_USER_GID} --create-home --shell /bin/bash ${ARG_USR} && \
    # ensure correct permissions for the user
    chown -R ${ARG_USER_UID}:${ARG_USER_GID} /home/${ARG_USR} && \
    # add an .ssh directory for the keys
    mkdir -p /home/${ARG_USR}/.ssh && \
    # serial port permissions
    usermod -a -G dialout ${ARG_USR} && \
    usermod -a -G tty ${ARG_USR}


# Instal STMCubeIDE
##################################
# installation needs to be as root
USER root
WORKDIR /opt/
# copy the IDE archive
# en.st-stm32cubeide_1.14.0_19471_20231121_1200_amd64.deb_bundle.sh.zip
ARG STIDE_SH="st-stm32cubeide_${ARG_STIDE_V}_amd64.deb_bundle.sh"
COPY "${ARG_DOCK_STM_FPATH}/en.${STIDE_SH}.zip" ./

RUN unzip "en.${STIDE_SH}.zip" -d cubeide && \
    rm "en.${STIDE_SH}.zip"               && \
    # permissions
    chmod a+x cubeide/${STIDE_SH}     && \
    # extract tar ball
    cd cubeide                        && \
    ./${STIDE_SH} --tar -xvf -C ./    && \
    # run the installer
    export LICENSE_ALREADY_ACCEPTED=1 && \
    ./setup.sh                        && \
    # clean up
    rm -rf /opt/cubeide/              

##############################
USER ${ARG_USR}
WORKDIR /home/${ARG_USR}
ENV LANG=${ARG_TZ_LANG}
ENV LANGUAGE=${ARG_TZ_LANG}
ENV LC_ALL=${ARG_TZ_LANG}

