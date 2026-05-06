
# Stop Plymouth on the host OS (because it's displaying the balena logo)
# See https://forums.balena.io/t/blacklist-drivers-in-host-os/163437/25
DBUS_SYSTEM_BUS_ADDRESS=unix:path=/host/run/dbus/system_bus_socket \
  dbus-send \
  --system \
  --print-reply \
  --dest=org.freedesktop.systemd1 \
  /org/freedesktop/systemd1 \
  org.freedesktop.systemd1.Manager.StopUnit \
  string:plymouth-start.service string:replace

# Remove Nouveau modules
sleep 6
echo 0 > /sys/class/vtconsole/vtcon1/bind
sleep 2
rmmod nouveau
sleep 2

# unload nvidiafb - it's a driver that gets loaded for some, but not all cards.
rmmod nvidiafb
sleep 2


# For loading firmware into the card
# ***** Make sure to change the line below to match your driver version in the Dockerfile! *****
# see https://blog.balena.io/giving-you-more-control-over-firmware-in-balenaos/

cp /usr/src/nvidia/NVIDIA-Linux-x86_64-580.142/firmware/gsp_ga10x.bin /extra-firmware/gsp_ga10x.bin


# Insert Nvidia modules
insmod /nvidia/driver/nvidia.ko
insmod /nvidia/driver/nvidia-modeset.ko
insmod /nvidia/driver/nvidia-uvm.ko

/usr/bin/nvidia-smi
nvidia-modprobe

sleep infinity
