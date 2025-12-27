FROM ubuntu:jammy

WORKDIR /usr/src

ENV DEBIAN_FRONTEND noninteractive

# Install Nvidia driver. Must match version in gpu container exactly.
# See https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa for version list.
RUN \ 
    apt-get update && \
    apt install -y software-properties-common && \
    add-apt-repository ppa:graphics-drivers/ppa && \
    apt update && \
    apt install -y nvidia-driver-580


# Install PyTorch
RUN \
    apt update && \
    apt install -y python3-pip && \
    pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu130

COPY *.py ./
COPY *.sh ./

CMD ["bash", "start.sh"]
