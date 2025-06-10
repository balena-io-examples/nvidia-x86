FROM balenalib/genericx86-64-ext-ubuntu:bionic

WORKDIR /usr/src

ENV DEBIAN_FRONTEND noninteractive

# Set variables for the Yocto version of the OS
ENV YOCTO_VERSION=6.6
ENV YOCTO_KERNEL=${YOCTO_VERSION}-yocto-standard

# Set variables to download proper NVIDIA driver
ENV NVIDIA_DRIVER_VERSION=570.153.02
ENV NVIDIA_DRIVER=NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}

# Install some prereqs
RUN install_packages git wget unzip build-essential libelf-dev bc libssl-dev bison flex software-properties-common libglvnd-dev cmake

WORKDIR /usr/src/nvidia

RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-keyring_1.1-1_all.deb && \
    dpkg -i cuda-keyring_1.1-1_all.deb && \
    rm cuda-keyring_1.1-1_all.deb

# Download and compile NVIDIA driver
RUN \
    curl -fsSL -O https://us.download.nvidia.com/XFree86/Linux-x86_64/$NVIDIA_DRIVER_VERSION/$NVIDIA_DRIVER.run && \
    chmod +x ./${NVIDIA_DRIVER}.run && \
    ./${NVIDIA_DRIVER}.run --extract-only && \
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
    --skip-depmod \
    --expert 
    
    
# Install CUDA Toolkit for Ubuntu per https://developer.nvidia.com/cuda-downloads
RUN \
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin && \
    mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600 && \
    add-apt-repository "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /" && \
    apt-get update && \
    apt-get -y install cuda
    
ENV PATH="/usr/local/cuda-12.1/bin:$PATH"
ENV LD_LIBRARY_PATH="/usr/local/cuda-12.1/lib64:$LD_LIBRARY_PATH"

# Compile one CUDA sample application
RUN \
    git clone https://github.com/NVIDIA/cuda-samples.git --branch v12.1 /usr/local/cuda-samples && \
    cd /usr/local/cuda-samples/Samples/1_Utilities/deviceQuery && \
    make -j8
    
WORKDIR /usr/src/app

COPY *.sh ./

CMD ["bash", "start.sh"]
