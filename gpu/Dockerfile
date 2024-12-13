FROM balenalib/genericx86-64-ext:bullseye-run-20211030

WORKDIR /usr/src

ENV DEBIAN_FRONTEND noninteractive

# Set some variables to download the proper header modules
ENV VERSION="2.107.8%2Brev1"
ENV BALENA_MACHINE_NAME="genericx86-64-ext"

# Set variables for the Yocto version of the OS
ENV YOCTO_VERSION=5.10.43
ENV YOCTO_KERNEL=${YOCTO_VERSION}-yocto-standard

# Set variables to download proper NVIDIA driver
ENV NVIDIA_DRIVER_VERSION=470.86
ENV NVIDIA_DRIVER=NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}

# Install some prereqs
RUN install_packages git wget unzip build-essential libelf-dev bc libssl-dev bison flex software-properties-common

WORKDIR /usr/src/kernel_source

# Causes a pipeline to produce a failure return code if any command errors. 
# Normally, pipelines only return a failure if the last command errors. 
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Download the kernel source then prepare kernel source to build a module.
RUN \
    curl -fsSL "https://files.balena-cloud.com/images/${BALENA_MACHINE_NAME}/${VERSION}/kernel-modules-headers.tar.gz" \
        | tar xz --strip-components=2 && \
    make -C build modules_prepare -j"$(nproc)"

# required if using install-libglvnd from nvidia-installer below
RUN install_packages libglvnd-dev

WORKDIR /usr/src/nvidia

# Download and compile NVIDIA driver
RUN \
    curl -fsSL -O https://us.download.nvidia.com/XFree86/Linux-x86_64/$NVIDIA_DRIVER_VERSION/$NVIDIA_DRIVER.run && \
    chmod +x ./${NVIDIA_DRIVER}.run && \
    ./${NVIDIA_DRIVER}.run --extract-only && \
    # Install userspace portion, needed if container will also have CUDA etc...
    # Not needed if just building kernel module. 
    # Do include in any application container.
    ./${NVIDIA_DRIVER}/nvidia-installer \
    --ui=none \
    --no-questions \
    --no-drm \
    --no-x-check \
    --no-systemd \
    --no-kernel-module \
    --no-distro-scripts \
    --install-compat32-libs \
    --no-nouveau-check \
    --no-rpms \
    --no-backup \
    --no-abi-note \
    --no-check-for-alternate-installs \
    --no-libglx-indirect \
    --install-libglvnd \
    --x-prefix=/tmp/null \
    --x-module-path=/tmp/null \
    --x-library-path=/tmp/null \
    --x-sysconfig-path=/tmp/null \
    --kernel-name=${YOCTO_KERNEL} \
    --skip-depmod \
    --expert && \
    make -C ${NVIDIA_DRIVER}/kernel KERNEL_MODLIB=/usr/src/kernel_source IGNORE_CC_MISMATCH=1 modules

WORKDIR /nvidia/driver

RUN find /usr/src/nvidia/${NVIDIA_DRIVER}/kernel -name "*.ko" -exec mv {} . \;

WORKDIR /usr/src/app
COPY *.sh ./

ENTRYPOINT ["/bin/bash", "/usr/src/app/entry.sh"]
