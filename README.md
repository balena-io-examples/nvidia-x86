# nvidia-x86 on balena
Example of using an Nvidia GPU in an x86 device on the balena platform. (Work in progress... ) See the accomanying blog post (coming soon) for more details!

## How it works
### gpu container
This is the main container in this example and the only one you need to obtain GPU access from within your container or for any other containers in the application. It downloads the kernel source files for our exact OS version and uses them, along with the driver file downloaded from Nvidia to build the required Nvidia kernel modules. Finally, the `entry.sh` file unloads the current Nouveau driver if it's running and loads the Nvidia modules.

Before using this example, you'll need to make sure that you've set the variables at the top of the Dockerfile:
- `VERSION` is the version of balenaOS being used on your device. This needs to be URL-encoded, so a plus sign (+) if present needs to be written as `%2B`.
- `BALENA_MACHINE_NAME` is the device type of your balenaOS from [this list](https://www.balena.io/docs/reference/hardware/devices/)
- `YOCTO_VERSION` is the version of Yocto Linux used to build your version of balenaOS. You can find it by logging into your host OS and typing: `uname -r`
- `NVIDIA_DRIVER_VERSION` is the version of the Nvidia driver you want to download and build using the list found [here]( https://www.nvidia.com/en-us/drivers/unix/) Usually, you can use the "Latest Production Branch Version". Be sure to use the eaxct same driver version in any other containers that need to access the GPU. 
