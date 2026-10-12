{ config, lib, pkgs, ... }:

{
  # ---------------------------------------------------------
  # 1. Enable Unfree Packages
  # ---------------------------------------------------------
  # NVIDIA drivers and CUDA tools are proprietary.
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"
      "cuda_nvcc"
      "cuda_cudart"
    ];

  # ---------------------------------------------------------
  # 2. Graphics Subsystem & 32-bit Support
  # ---------------------------------------------------------
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Crucial for 32-bit apps like Steam, Wine, Proton
    extraPackages = with pkgs; [
      nvidia-vaapi-driver # VA-API hardware acceleration for Firefox/Chrome
    ];
  };

  # ---------------------------------------------------------
  # 3. Kernel & Display Server Drivers
  # ---------------------------------------------------------
  # Instruct X11 / Wayland to use the nvidia driver
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Modesetting is required for Wayland compositors (Hyprland, Sway, GNOME Wayland)
    modesetting.enable = true;

    # Power management (experimental, but improves suspend/resume stability)
    powerManagement.enable = false; # Set to true if you experience suspend/resume sleep issues
    powerManagement.finegrained = false; # Mostly used in Prime offload mode for laptops

    # Use the NVreg open-source kernel modules (Turing RTX 2000+ or newer)
    # Set to `true` for modern GPUs (RTX 20xx, 30xx, 40xx, etc.)
    # Set to `false` for older GPUs (GTX 16xx, 10xx, 9xx, etc.)
    open = true;

    # Expose the nvidia-settings GUI utility
    nvidiaSettings = true;

    # Driver channel: stable, beta, production, etc.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # ---------------------------------------------------------
    # 4. Hybrid Graphics / Laptop PRIME (Uncomment if on a Laptop)
    # ---------------------------------------------------------
    # Run `lspci | grep -E "VGA|3D"` to get PCI IDs.
    # E.g., `01:00.0` translates to `PCI:1:0:0`
    # prime = {
    #   # Offload mode: Nvidia runs only when called via `nvidia-offload %command%`
    #   offload = {
    #     enable = true;
    #     enableOffloadCmd = true;
    #   };
    #
    #   # Or Sync mode (Nvidia always on, uses more battery, higher performance):
    #   # sync.enable = true;
    #
    #   intelBusId = "PCI:0:2:0";
    #   # amdgpuBusId = "PCI:5:0:0"; # Use this instead if your CPU is AMD
    #   nvidiaBusId = "PCI:1:0:0";
    # };
  };

  # ---------------------------------------------------------
  # 5. Wayland & Hardware Video Acceleration Environment
  # ---------------------------------------------------------
  environment.sessionVariables = {
    # VA-API driver selection for video decoding
    LIBVA_DRIVER_NAME = "nvidia";

    # Wayland compatibility variables (useful for Electron/GBM)
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    # NVD_BACKEND = "direct"; # Uncomment if using nvidia-vaapi-driver with Firefox
  };

  # ---------------------------------------------------------
  # 6. Helpful Utilities
  # ---------------------------------------------------------
  environment.systemPackages = with pkgs; [
    nvtopPackages.nvidia # Clean GPU monitor in terminal (like htop for GPU)
  ];
}
