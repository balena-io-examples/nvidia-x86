import torch

print("Checking for CUDA device(s) for PyTorch...")

print("------------------------------------------")
print("Torch CUDA available: {}".format(torch.cuda.is_available()))

print("Torch CUDA current device: {}".format(torch.cuda.current_device()))

print("Torch CUDA device info: {}".format(torch.cuda.device(0)))

print("Torch CUDA device count: {}".format(torch.cuda.device_count()))

print("Torch CUDA device name: {}".format(torch.cuda.get_device_name(0)))
