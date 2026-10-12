{ config, lib, pkgs, ... }:

let
  username = "stdil"; # Replace with your preferred username
in
{
  # ---------------------------------------------------------
  # 1. Shell Configuration
  # ---------------------------------------------------------
  # Enable user shell system-wide so PAM and login environments recognize it
  programs.zsh.enable = true;
  # programs.fish.enable = true;

  # Set the default shell system-wide
  users.defaultUserShell = pkgs.zsh;

  # ---------------------------------------------------------
  # 2. User Account Definition
  # ---------------------------------------------------------
  users.users.${username} = {
    isNormalUser = true;
    description = "Primary User";
    shell = pkgs.zsh;

    # -------------------------------------------------------
    # Essential Group Memberships
    # -------------------------------------------------------
    extraGroups = [
      # Administrative & System
      "wheel"           # Sudo / administrative privileges
      "systemd-journal" # Read systemd logs without full root

      # Hardware & Devices
      "networkmanager"  # Modify Wi-Fi and VPN without root password
      "video"           # Access to display devices, backlight, webcams
      "audio"           # Direct ALSA/sound card access
      "input"           # Access to input devices (gamepads, controllers)
      "render"          # Direct rendering infrastructure (DRI/KMS/OpenCL/ROCm)
      "storage"         # Mounting external drives / block devices
      "disk"            # Access to raw disks (useful for flashing ISOs)

      # Virtualization / Containers (uncomment if used)
      "docker"        # Docker daemon access
      # "libvirtd"      # KVM / QEMU / Virt-Manager
      # "kvm"           # Kernel-based Virtual Machine access

      # Hardware tools & wireless
      # "dialout"       # Serial devices / Arduino / ESP32 flashing
      # "plugdev"       # Custom USB devices / YubiKey / flashing tools
    ];

    # -------------------------------------------------------
    # Authentication & SSH Keys
    # -------------------------------------------------------
    # Optional: Initial password (change immediately via `passwd` after first boot)
    # initialPassword = "nixos";

    # Alternatively, supply an existing hashed password (generated via `mkpasswd -m sha-512`):
    # hashedPassword = "$6$...";

    # Public SSH keys for remote login:
    openssh.authorizedKeys.keys = [
      # "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI... user@machine"
    ];

    # Packages specific to this user only (if not using Home Manager):
    packages = with pkgs; [
      # git
      # tree
    ];
  };

  # ---------------------------------------------------------
  # 3. User & Group Safety Settings
  # ---------------------------------------------------------
  users.mutableUsers = true;
  # Set `users.mutableUsers = false;` if you want a fully declarative/immutable
  # system where passwords cannot be modified outside of Nix configuration.
}
