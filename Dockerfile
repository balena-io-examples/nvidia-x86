ARG BASE=balenalib/intel-nuc-ubuntu:latest
ENV RESINOS_VERSION=2.39.0%2Brev2.prod
ENV YOCTO_VERSION=5.0.3
ENV YOCTO_KERNEL=${YOCTO_VERSION}-yocto-standard
ENV NVIDIA_DRIVER_VERSION=${NVIDIA_DRIVER}.40
ENV NVIDIA_DRIVER_RUN=NVIDIA-Linux-x86_64-${NVIDIA_DRIVER_VERSION}.run
RUN wget -nv https://files.resin.io/images/intel-nuc/${RESINOS_VERSION}/kernel_modules_headers.tar.gz && \
tar -xzvf kernel_modules_headers.tar.gz && \
mkdir -p /lib/modules/${YOCTO_KERNEL} && \
cp -r kernel_modules_headers /lib/modules/${YOCTO_KERNEL}/build && \
ln -s /lib64/ld-linux-x86-64.so.2 /lib/ld-linux-x86-64.so.2 && \
wget -nv http://uk.download.nvidia.com/XFree86/Linux-x86_64/${NVIDIA_DRIVER_VERSION}/${NVIDIA_DRIVER_RUN} && \
chmod +x ./${NVIDIA_DRIVER_RUN} && \
mkdir -p /nvidia && \
mkdir -p /nvidia/driver && \
./${NVIDIA_DRIVER_RUN} \
--kernel-source-path=/tmp/kernel_modules_headers/ \
--kernel-install-path=/nvidia/driver \
--ui=none \
--no-drm \
--no-x-check \
--install-compat32-libs \
--no-nouveau-check \
--no-nvidia-modprobe \
--no-rpms \
--no-backup \
--no-check-for-alternate-installs \
--no-libglx-indirect \
--no-install-libglvnd \
--x-prefix=/tmp/null \
--x-module-path=/tmp/null \
--x-library-path=/tmp/null \
--x-sysconfig-path=/tmp/null \
--no-glvnd-egl-client \
--no-glvnd-glx-client \
--kernel-name=${YOCTO_KERNEL} && \
rm -rf /tmp/*
