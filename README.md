# nvidia-x86 on balena
Example of using an Nvidia GPU in an x86 device on the balena platform. (Work in progress... ) See the accomanying blog post (coming soon) for more details!

Note that although these examples should work as-is, the resulting images are quite large and should be optimized for your particular use case. One possibility is to utilize [multistage builds](https://www.balena.io/docs/learn/deploy/build-optimization/#multi-stage-builds) to reduce the size of your containers. Below is a summary of the containers in this project, with all of the details following in the next section.

| Service | Image Size | Description |
| ------------ | ----------- | ----------- |
| gpu | 2.28 GB | main exmaple - downloads, builds and installs gpu kernel modules |
| cuda | 8.60 GB | example container with CUDA toolkit installed |
| app | 7.26 GB | example of app container installing PyTorch |
| nv-pytorch | 2.28 GB | example of using an Nvidia base image for PyTorch |

## How it works
### gpu container
This is the main container in this example and the only one you need to obtain GPU access from within your container or for any other containers in the application. It downloads the kernel source files for our exact OS version and uses them, along with the driver file downloaded from Nvidia to build the required Nvidia kernel modules. Finally, the `entry.sh` file unloads the current Nouveau driver if it's running and loads the Nvidia modules.

This container also provides CUDA compiled application support, though not development support - see the CUDA container example for development use. You could use this image as a base image, build on top of the current example, or use alongside other containers to provide them with gpu access.

Before using this example, you'll need to make sure that you've set the variables at the top of the Dockerfile:
- `VERSION` is the version of balenaOS being used on your device. This needs to be URL-encoded, so a plus sign (+) if present needs to be written as `%2B`.
- `BALENA_MACHINE_NAME` is the device type of your balenaOS from [this list](https://www.balena.io/docs/reference/hardware/devices/)
- `YOCTO_VERSION` is the version of Yocto Linux used to build your version of balenaOS. You can find it by logging into your host OS and typing: `uname -r`
- `NVIDIA_DRIVER_VERSION` is the version of the Nvidia driver you want to download and build using the list found [here]( https://www.nvidia.com/en-us/drivers/unix/) Usually, you can use the "Latest Production Branch Version". Be sure to use the eaxct same driver version in any other containers that need to access the GPU. 

If this container is set up and running properly, you should see the output below (for your gpu model) in the terminal:
```
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 470.86       Driver Version: 470.86       CUDA Version: 11.4     |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|                               |                      |               MIG M. |
|===============================+======================+======================|
|   0  Quadro P400         Off  | 00000000:01:00.0 Off |                  N/A |
| 22%   37C    P0    N/A /  N/A |      0MiB /  2000MiB |      0%      Default |
|                               |                      |                  N/A |
+-------------------------------+----------------------+----------------------+
                                                                               
+-----------------------------------------------------------------------------+
| Processes:                                                                  |
|  GPU   GI   CI        PID   Type   Process name                  GPU Memory |
|        ID   ID                                                   Usage      |
|=============================================================================|
|  No running processes found                                                 |
+-----------------------------------------------------------------------------+ 
```
### cuda container
The CUDA container example demonstrates how to install and use the CUDA toolkit (for CUDA development, etc...) in a separate container from the gpu container. 
