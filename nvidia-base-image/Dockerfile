FROM nvcr.io/nvidia/pytorch:25.11-py3

# Starting with an Nvidia base image above, see: https://catalog.ngc.nvidia.com/
 
ENV DEBIAN_FRONTEND noninteractive

WORKDIR /usr/src

# Install Nvidia driver. Must match version in gpu container exactly.
# See https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa for version list.
RUN \ 
    apt-get update && \
    apt install -y software-properties-common && \
    add-apt-repository ppa:graphics-drivers/ppa && \
    apt update && \
    apt install -y nvidia-driver-580
    
WORKDIR /workspace
   
COPY *.py ./

COPY *.sh ./

CMD ["bash", "start.sh"]
