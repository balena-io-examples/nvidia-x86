# nvidia-x86 on balena
Example of using an Nvidia GPU in an x86 device on the balena platform. See the accompanying blog post (coming soon) for more details!

Note that although these examples should work as-is, the resulting images are quite large and should be optimized for your particular use case. One possibility is to utilize [multistage builds](https://www.balena.io/docs/learn/deploy/build-optimization/#multi-stage-builds) to reduce the size of your containers. Below is a summary of the containers in this project, with all of the details following in the next section.

| Service | Image Size | Description |
| ------------ | ----------- | ----------- |
| gpu | 2.28 GB | main example - downloads, builds and installs gpu kernel modules |
| cuda | 8.60 GB | example container with CUDA toolkit installed |
| app | 7.26 GB | example of app container installing PyTorch |
| nv-pytorch | 14.96 GB | example of using an Nvidia base image for PyTorch |

## How it works
### gpu container
This is the main container in this example and the only one you need to obtain GPU access from within your container or for any other containers in the application. It downloads the kernel source files for our exact OS version and uses them, along with the driver file downloaded from Nvidia to build the required Nvidia kernel modules. Finally, the `entry.sh` file unloads the current Nouveau driver if it's running and loads the Nvidia modules.

This container also provides CUDA compiled application support, though not development support - see the CUDA container example for development use. You could use this image as a base image, build on top of the current example, or use alongside other containers to provide them with gpu access.

Before using this example, you'll need to make sure that you've set the variables at the top of the Dockerfile:
- `VERSION` is the version of balenaOS being used on your device. This needs to be URL-encoded, so a plus sign (+) if present needs to be written as `%2B`.
- `BALENA_MACHINE_NAME` is the device type of your balenaOS from [this list](https://www.balena.io/docs/reference/hardware/devices/)
- `YOCTO_VERSION` is the version of Yocto Linux used to build your version of balenaOS. You can find it by logging into your host OS and typing: `uname -r`
- `NVIDIA_DRIVER_VERSION` is the version of the Nvidia driver you want to download and build using the list found [here]( https://www.nvidia.com/en-us/drivers/unix/) Usually, you can use the "Latest Production Branch Version". Be sure to use the exact same driver version in any other containers that need access to the GPU. 

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
The CUDA container example demonstrates how to install and use the CUDA toolkit (for CUDA development, etc...) in a separate container from the gpu container. The gpu container must be running first for this container to work properly. You'll need to supply a few variables for the Dockerfile, and they must match the values used in the accomanying gpu container as described above. 
- `YOCTO_VERSION` is the version of Yocto Linux used to build your version of balenaOS. You can find it by logging into your host OS and typing: `uname -r`
- `NVIDIA_DRIVER_VERSION` is the version of the Nvidia driver you want to download and build using the list found [here]( https://www.nvidia.com/en-us/drivers/unix/) Usually, you can use the "Latest Production Branch Version". Be sure to use the eaxct same driver version as in the gpu container.

This is one example of separating the GPU kernel module loading from an application container. Note that all containers needing GPU access must load Nvidia drivers that exactly match the version used in the gpu container. In this case, the same driver from the same Nvidia source as the gpu container is used. (In the app container example below, the distribution's Nvidia drivers are used instead.) If this container is running properly, you should see the following output in the logs:
```
 cuda  /usr/local/cuda-11.5/samples/1_Utilities/deviceQuery/deviceQuery Starting...
 cuda  
 cuda   CUDA Device Query (Runtime API) version (CUDART static linking)
 cuda  
 cuda  Detected 1 CUDA Capable device(s)
 cuda  
 cuda  Device 0: "Quadro P400"
 cuda    CUDA Driver Version / Runtime Version          11.5 / 11.5
 cuda    CUDA Capability Major/Minor version number:    6.1
 cuda    Total amount of global memory:                 2000 MBytes (2097479680 bytes)
 cuda    (002) Multiprocessors, (128) CUDA Cores/MP:    256 CUDA Cores
 cuda    GPU Max Clock rate:                            1252 MHz (1.25 GHz)
 cuda    Memory Clock rate:                             2005 Mhz
 cuda    Memory Bus Width:                              64-bit
 cuda    L2 Cache Size:                                 524288 bytes
 cuda    Maximum Texture Dimension Size (x,y,z)         1D=(131072), 2D=(131072, 65536), 3D=(16384, 16384, 16384)
 cuda    Maximum Layered 1D Texture Size, (num) layers  1D=(32768), 2048 layers
 cuda    Maximum Layered 2D Texture Size, (num) layers  2D=(32768, 32768), 2048 layers
 cuda    Total amount of constant memory:               65536 bytes
 cuda    Total amount of shared memory per block:       49152 bytes
 cuda    Total shared memory per multiprocessor:        98304 bytes
 cuda    Total number of registers available per block: 65536
 cuda    Warp size:                                     32
 cuda    Maximum number of threads per multiprocessor:  2048
 cuda    Maximum number of threads per block:           1024
 cuda    Max dimension size of a thread block (x,y,z): (1024, 1024, 64)
 cuda    Max dimension size of a grid size    (x,y,z): (2147483647, 65535, 65535)
 cuda    Maximum memory pitch:                          2147483647 bytes
 cuda    Texture alignment:                             512 bytes
 cuda    Concurrent copy and kernel execution:          Yes with 2 copy engine(s)
 cuda    Run time limit on kernels:                     No
 cuda    Integrated GPU sharing Host Memory:            No
 cuda    Support host page-locked memory mapping:       Yes
 cuda    Alignment requirement for Surfaces:            Yes
 cuda    Device has ECC support:                        Disabled
 cuda    Device supports Unified Addressing (UVA):      Yes
 cuda    Device supports Managed Memory:                Yes
 cuda    Device supports Compute Preemption:            Yes
 cuda    Supports Cooperative Kernel Launch:            Yes
 cuda    Supports MultiDevice Co-op Kernel Launch:      Yes
 cuda    Device PCI Domain ID / Bus ID / location ID:   0 / 1 / 0
 cuda    Compute Mode:
 cuda       < Default (multiple host threads can use ::cudaSetDevice() with device simultaneously) >
 cuda  
 cuda  deviceQuery, CUDA Driver = CUDART, CUDA Driver Version = 11.5, CUDA Runtime Version = 11.5, NumDevs = 1
 cuda  Result = PASS
 ```
 
 ### app container
 The app container is another example of how you can separate the GPU access setup from an application that requires GPU access. In this case, we use the Ubuntu distribution's drivers instead of the Nvidia drivers. However, the version must still match the one used in the gpu container (which is required to be running alongside this one). You can see a list of the available driver versions [here](https://launchpad.net/~graphics-drivers/+archive/ubuntu/ppa). The "app" we install is PyTorch and then a Python example is run to confirm CUDA GPU access. If the container is running properly, you should see the following output, customized for your GPU model:
```
 app  Checking for CUDA device(s) for PyTorch...
 app  ------------------------------------------
 app  Torch CUDA available: True
 app  Torch CUDA current device: 0
 app  Torch CUDA device info: <torch.cuda.device object at 0x7f7c749ed610>
 app  Torch CUDA device count: 1
 app  Torch CUDA device name: Quadro P400
```

### nv-pytorch
This is an example of using a pre-built container from the [Nvidia NGC Catalog](https://catalog.ngc.nvidia.com/). In this case we use their PyTorch container as a base image, install the Nvidia drivers on top of that (using the same version as in the gpu container which is required to be running alongside this) and then run a simple Python script that confirms CUDA GPU access. Note that we are not installing/running the Container Toolkit! If this container is running properly, you should see the following output customized for your GPU model:
```
 nv-pytorch  Checking for CUDA device(s) for PyTorch...
 nv-pytorch  ------------------------------------------
 nv-pytorch  Torch CUDA available: True
 nv-pytorch  Torch CUDA current device: 0
 nv-pytorch  Torch CUDA device info: <torch.cuda.device object at 0x7f7c749ed610>
 nv-pytorch  Torch CUDA device count: 1
 nv-pytorch  Torch CUDA device name: Quadro P400
```
