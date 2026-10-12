{ config, lib, pkgs, ... }:

{
  # ---------------------------------------------------------
  # 1. NixOS State Version
  # ---------------------------------------------------------
  # Keep this pinned to the NixOS version where the system was first installed.
  # Do NOT change this value during routine channel/flake updates.
  system.stateVersion = lib.mkDefault "26.05";

  # ---------------------------------------------------------
  # 2. Localization & Time Zone
  # ---------------------------------------------------------
  time.timeZone = lib.mkDefault "Asia/Tehran"; # Override with your local timezone (e.g. "America/New_York", "Europe/London")

  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # ---------------------------------------------------------
  # 3. Console & TTY Settings
  # ---------------------------------------------------------
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkDefault "us";
    # Early KMS font configuration for HiDPI/early boot
    earlySetup = true;
  };

  # ---------------------------------------------------------
  # 4. Bootloader Base Defaults (UEFI / systemd-boot)
  # ---------------------------------------------------------
  boot.loader = {
    efi.canTouchEfiVariables = lib.mkDefault true;
    systemd-boot = {
      enable = lib.mkDefault true;
      # Keep boot menu uncluttered; keeps only the last 10 generations
      configurationLimit = lib.mkDefault 10;
      # Disable editing kernel params at boot time without password (security)
      editor = false;
    };
    timeout = lib.mkDefault 3;
  };

  # ---------------------------------------------------------
  # 5. Core System Services & Maintenance
  # ---------------------------------------------------------
  services = {
    # Automatic periodic SSD TRIM to maintain NVMe/SSD drive health & speed
    fstrim = {
      enable = true;
      interval = "weekly";
    };

    # Systemd journal log limits (prevents logs from filling your root disk)
    journald.extraConfig = ''
      SystemMaxUse=1G
      SystemMaxFileSize=128M
      MaxRetentionSec=1month
    '';

    # Enable D-Bus broker (modern, high-performance D-Bus daemon)
    dbus.implementation = "broker";

    # Automatic generation cleanup for boot entries
    logrotate.enable = true;
  };

  # ---------------------------------------------------------
  # 6. Global Shell Aliases & Environment
  # ---------------------------------------------------------
  environment.shellAliases = {
    # Nix maintenance helpers
    rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)";
    nix-clean = "sudo nix-collect-garbage -d && nix-collect-garbage -d";
  };

  environment.variables = {
    EDITOR = "vim";  # Change to "nvim", "vim", or "micro" as desired
    VISUAL = "vim";
  };

  # ---------------------------------------------------------
  # 7. Core Universal CLI Utilities
  # ---------------------------------------------------------
  # Essential utilities you expect to exist on any functioning Linux box
  environment.systemPackages = with pkgs; [
    # System inspection & monitoring
    btop
    htop
    fastfetch
    pciutils       # lspci
    usbutils       # lsusb
    lsof

    # File & archive management
    zip
    unzip
    p7zip
    file
    which
    tree
    ripgrep        # Fast grep (rg)
    fd             # Fast find

    # Core editing & text
    vim
    nano
    jq             # JSON processor

    # Disk & filesystem tools
    e2fsprogs
    dosfstools
    btrfs-progs
    parted
  ];
}
