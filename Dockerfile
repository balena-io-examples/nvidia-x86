FROM balenalib/genericx86-64-ext

WORKDIR /usr/src

ENV DEBIAN_FRONTEND noninteractive

# Set some variables to download the proper header modules
ENV VERSION '2.83.18+rev1.dev'
ENV BALENA_MACHINE_NAME 'genericx86-64-ext'

# Set variables for the Yocto version of the OS
ENV YOCTO_VERSION 5.10.43
ENV YOCTO_KERNEL ${YOCTO_VERSION}-yocto-standard

# Set variables to download proper NVIDIA driver
ENV NVIDIA_DRIVER_VERSION 470.82.00
ENV NVIDIA_DRIVER NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run

# Install some prereqs
RUN apt-get update && apt-get install -y git wget unzip build-essential libelf-dev bc libssl-dev bison flex

# Download the header modules for our OS version
RUN \
    mkdir sources && \
    curl -fsSL "https://files.balena-cloud.com/images/${BALENA_MACHINE_NAME}/${VERSION/+/%2B}/kernel_source.tar.gz" \
        | tar xz --strip-components=2 -C /usr/src/sources/ && \
    ln -sf /usr/lib/x86_64-linux-gnu/libGL.so.1 /usr/lib/libGL.so.1 && \
    mkdir -p /lib/modules/${YOCTO_KERNEL} && \
    make -C /usr/src/sources/build modules_prepare -j"$(nproc)"

# Download and compile NVIDIA driver
RUN \
    mkdir nvidia && cd nvidia && \
    wget -nv https://us.download.nvidia.com/XFree86/Linux-x86_64/$NVIDIA_DRIVER_VERSION/$NVIDIA_DRIVER && \
    chmod +x ./${NVIDIA_DRIVER} && \
    mkdir -p /nvidia/driver && \
    ./${NVIDIA_DRIVER} \
    --kernel-source-path=/usr/src/sources/build/ \
    --kernel-install-path=/nvidia/driver \
    --ui=none \
    --no-drm \
    --no-x-check \
    --install-compat32-libs \
    --no-nouveau-check \
    --no-rpms \
    --no-backup \
    --no-check-for-alternate-installs \
    --no-libglx-indirect \
    --no-install-libglvnd \
    --x-prefix=/tmp/null \
    --x-module-path=/tmp/null \
    --x-library-path=/tmp/null \
    --x-sysconfig-path=/tmp/null \
    --kernel-name=${YOCTO_KERNEL}
    
WORKDIR /usr/src/app
COPY *.sh ./

ENTRYPOINT ["/bin/bash", "/usr/src/app/entry.sh"]
