{ config, lib, pkgs, ... }:

{
  # ---------------------------------------------------------
  # 1. CPU Microcode Updates (Ryzen / EPYC)
  # ---------------------------------------------------------
  # Ensures AMD CPU receives microcode security and stability patches
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # ---------------------------------------------------------
  # 2. Kernel & Early KMS
  # ---------------------------------------------------------
  # Load the amdgpu module early in initramfs for clean boot and Wayland compositors
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Tell X11 / Wayland to use the amdgpu driver
  services.xserver.videoDrivers = [ "amdgpu" ];

  # ---------------------------------------------------------
  # 3. Graphics & Hardware Acceleration (Mesa / RADV / VA-API)
  # ---------------------------------------------------------
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Required for 32-bit games (Steam, Wine, Proton)

    extraPackages = with pkgs; [
      # Video Acceleration (VA-API / VDPAU)
      libva
      libvdpau-va-gl

      # Compute / OpenCL / ROCm (Uncomment if needed for Blender, ML, etc.)
      # rocmPackages.clr
      # rocmPackages.clr.icd
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      libva
      libvdpau-va-gl
    ];
  };

  # ---------------------------------------------------------
  # 4. Environment Variables
  # ---------------------------------------------------------
  environment.sessionVariables = {
    # Force RADV (Vulkan driver from Mesa) over AMDVLK
    AMD_VULKAN_ICD = "RADV";

    # VA-API driver selection for video decoding in browsers and media players
    LIBVA_DRIVER_NAME = "radeonsi";
    VDPAU_DRIVER = "radeonsi";
  };

  # ---------------------------------------------------------
  # 5. Monitoring & Diagnostic Utilities
  # ---------------------------------------------------------
  environment.systemPackages = with pkgs; [
    libva-utils        # Includes `vainfo` for checking hardware video decoding
    vulkan-tools       # Includes `vkcube` and `vulkaninfo`
    clinfo             # For checking OpenCL support
    nvtopPackages.amd  # Terminal GPU monitor for AMD
    # lact             # GUI GPU overclocking/fan control tool (uncomment if desired)
  ];
}
