{ config, lib, pkgs, ... }:

{
  # ---------------------------------------------------------
  # 1. CPU Microcode Updates
  # ---------------------------------------------------------
  # Ensures the CPU receives microcode patches for security and stability.
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # ---------------------------------------------------------
  # 2. Kernel Modules & Parameters
  # ---------------------------------------------------------
  boot.initrd.kernelModules = [ "i915" ]; # Load Intel graphics early in initramfs

  # Optional power-saving / modern features (uncomment if desired):
  boot.kernelParams = [
    "i915.enable_guc=3" # Enable GuC/HuC firmware on Gen 9+ (Skylake and newer)
  ];

  # ---------------------------------------------------------
  # 3. Graphics & Hardware Acceleration (VA-API / QuickSync)
  # ---------------------------------------------------------
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Required for 32-bit apps like Steam / Wine

    extraPackages = with pkgs; [
      # Modern VA-API driver (Broadwell 5th gen and newer: 2015+)
      intel-media-driver

      # OpenCL and compute acceleration
      intel-compute-runtime
      vpl-gpu-rt # Intel Video Processing Library (Quick Sync for modern GPUs)
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
      # intel-vaapi-driver
    ];
  };

  # ---------------------------------------------------------
  # 4. Environment Variables
  # ---------------------------------------------------------
  environment.sessionVariables = {
    # Force VA-API to prioritize the modern intel-media-driver (iHD)
    LIBVA_DRIVER_NAME = "iHD";
  };

  # ---------------------------------------------------------
  # 5. Useful Monitoring & Diagnostic Tools
  # ---------------------------------------------------------
  environment.systemPackages = with pkgs; [
    intel-gpu-tools # Includes `intel_gpu_top` for monitoring GPU usage
    libva-utils     # Includes `vainfo` for checking hardware acceleration
    clinfo          # For verifying OpenCL support
  ];
}
