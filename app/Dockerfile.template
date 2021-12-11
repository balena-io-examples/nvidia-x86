FROM balenalib/genericx86-64-ext-ubuntu:focal

WORKDIR /usr/src

ENV DEBIAN_FRONTEND noninteractive

# Install Nvidia driver. Must match version in gpu container exactly
RUN \
    apt-get update && \
    apt install -y software-properties-common && \
    add-apt-repository ppa:graphics-drivers/ppa && \
    apt update && \
    apt install -y nvidia-driver-470


# Install PyTorch and run sample to confirm CUDA GPU
RUN \
    apt update && \
    apt install -y python3-pip && \
    pip3 install torch==1.10.0+cu113 torchvision==0.11.1+cu113 torchaudio==0.10.0+cu113 -f https://download.pytorch.org/whl/cu113/torch_stable.html

COPY *.py ./
COPY *.sh ./

CMD ["bash", "start.sh"]
