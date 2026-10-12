{ config, lib, pkgs, ... }:

{
  # ---------------------------------------------------------
  # 1. Privilege Elevation & Sudo Configuration
  # ---------------------------------------------------------
  security.sudo = {
    enable = true;
    wheelNeedsPassword = true; # Require password for wheel group

    # Retain sudo privileges for a short duration (15 mins) per terminal
    extraConfig = ''
      Defaults env_reset, timestamp_timeout=15
      Defaults pwfeedback # Visual asterisks when typing passwords
    '';

    # Optional: Swap or complement with `doas` (lighter alternative)
    # security.doas.enable = true;
  };

  # ---------------------------------------------------------
  # 2. Polkit (PolicyKit) & Realtime Scheduling
  # ---------------------------------------------------------
  security.polkit.enable = true;

  # rtkit gives PipeWire and audio servers high-priority real-time scheduling
  # Prevents audio crackling and stutters under heavy CPU load
  security.rtkit.enable = true;

  # ---------------------------------------------------------
  # 3. PAM & Keyrings (Secrets Management)
  # ---------------------------------------------------------
  security.pam.services = {
    # Unlock GNOME Keyring automatically on login (works on Hyprland, Sway, GNOME)
    login.enableGnomeKeyring = true;
    # For display managers like SDDM or GDM
    # sddm.enableGnomeKeyring = true;
    # gdm.enableGnomeKeyring = true;

    # Optional: Support YubiKey / FIDO2 authentication
    # u2f = {
    #   enable = true;
    #   control = "sufficient"; # Or "required" for strict 2FA
    # };
  };

  # ---------------------------------------------------------
  # 4. Mandatory Access Control (AppArmor)
  # ---------------------------------------------------------
  security.apparmor = {
    enable = true;
    # Kill tasks violating strict profiles rather than just warning
    killUnconfinedConfined = false;
    packages = with pkgs; [
      apparmor-profiles
    ];
  };

  # ---------------------------------------------------------
  # 5. Kernel Hardening & Sysctl Parameters
  # ---------------------------------------------------------
  boot.kernel.sysctl = {
    # Hide kernel pointers in /proc to mitigate privilege escalation exploits
    "kernel.kptr_restrict" = 1;

    # Restrict dmesg log access to users with CAP_SYSLOG
    "kernel.dmesg_restrict" = 1;

    # Restrict unprivileged eBPF (reduces kernel attack surface)
    "kernel.unprivileged_bpf_disabled" = 1;

    # Enable ptrace protection (Yama LSM)
    # 1 = only parent process can ptrace children
    "kernel.yama.ptrace_scope" = 1;

    # Networking: Ignore bogus ICMP responses & protect against SYN floods
    "net.ipv4.tcp_syncookies" = 1;
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
    "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
    "net.ipv4.conf.all.accept_source_route" = 0;
    "net.ipv6.conf.all.accept_source_route" = 0;
  };

  # ---------------------------------------------------------
  # 6. Core Security & Secret Daemons
  # ---------------------------------------------------------
  # GNOME Keyring daemon for storing SSH keys, browser passwords, Git tokens
  services.gnome.gnome-keyring.enable = true;

  # GnuPG Agent with smartcard (YubiKey) support
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    # pinentryPackage = pkgs.pinentry-curses; # Use pinentry-gnome3 or pinentry-qt for GUI
  };

  # ---------------------------------------------------------
  # 7. Security Diagnostics & Inspection Tools
  # ---------------------------------------------------------
  environment.systemPackages = with pkgs; [
    apparmor-utils # aa-status, aa-enforce
    lynis          # System security auditing tool
    gnupg
    age            # Modern file encryption tool
    sops           # Secret management for Git / Nix
    pinentry-curses
  ];
}
