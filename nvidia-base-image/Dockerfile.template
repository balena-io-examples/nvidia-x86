FROM nvcr.io/nvidia/pytorch:21.11-py3

# Starting with an Nvidia base image above, see: https://catalog.ngc.nvidia.com/

ENV DEBIAN_FRONTEND noninteractive

# Install Nvidia driver. Must match version in gpu container exactly
RUN \
    apt-get update && \
    apt install -y software-properties-common && \
    add-apt-repository ppa:graphics-drivers/ppa && \
    apt update && \
    apt install -y nvidia-driver-470
    
WORKDIR /workspace
   
COPY *.py ./

COPY *.sh ./

CMD ["bash", "start.sh"]
