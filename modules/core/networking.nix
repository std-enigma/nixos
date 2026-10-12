{ config, lib, pkgs, ... }:

{
  # ---------------------------------------------------------
  # 1. Hostname & Network Manager
  # ---------------------------------------------------------
  networking = {
    # Replace with your machine's hostname (or set in host-specific config)
    hostName = lib.mkDefault "nixos";

    # Modern network manager (standard for desktop/laptop)
    networkmanager = {
      enable = true;
      # Use systemd-resolved backend for DNS handling
      dns = "systemd-resolved";
      # Randomize MAC address for Wi-Fi privacy (optional)
      wifi.macAddress = "random";
    };

    # Disable legacy wpa_supplicant backend to avoid conflicts with NetworkManager
    wireless.enable = false;

    # ---------------------------------------------------------
    # 2. DNS & Fallbacks
    # ---------------------------------------------------------
    # System-level fallback DNS servers if DHCP doesn't provide them
    nameservers = [
      "1.1.1.1"      # Cloudflare
      "1.0.0.1"
      "8.8.8.8"      # Google
    ];

    # ---------------------------------------------------------
    # 3. Firewall Configuration
    # ---------------------------------------------------------
    firewall = {
      enable = true;

      # Allow ping (ICMP) for diagnostics
      allowPing = true;

      # Explicit open ports (keep minimal)
      allowedTCPPorts = [
        22    # SSH (uncomment if running openssh)
        # 80    # HTTP
        # 443   # HTTPS
      ];
      allowedUDPPorts = [
        # 51820 # WireGuard
      ];

      # Open port ranges (e.g. for KDE Connect, LocalSend, or LAN gaming)
      allowedTCPPortRanges = [
        # { from = 1714; to = 1764; } # KDE Connect
      ];
      allowedUDPPortRanges = [
        # { from = 1714; to = 1764; } # KDE Connect
      ];
    };
  };

  # ---------------------------------------------------------
  # 4. Modern DNS Resolver (systemd-resolved)
  # ---------------------------------------------------------
  services.resolved = {
    enable = true;
    dnssec = "allow-downgrade";
    # Enable DNS-over-TLS (DoT) for encrypted lookups
    # Set to "true" for strict DoT or "opportunistic" for compatibility
    dnsovertls = "opportunistic";
    fallbackDns = [
      "1.1.1.1#cloudflare-dns.com"
      "9.9.9.9#dns.quad9.net"
    ];
  };

  # ---------------------------------------------------------
  # 5. Time Synchronization (NTP)
  # ---------------------------------------------------------
  # Keeps system clock synchronized across networks
  services.timesyncd.enable = true;

  # ---------------------------------------------------------
  # 6. Essential Networking CLI Tools
  # ---------------------------------------------------------
  environment.systemPackages = with pkgs; [
    # Monitoring & inspection
    ethtool
    iproute2
    iptables
    nethogs           # Monitor bandwidth per process
    wavemon           # Wi-Fi signal & adapter monitor in terminal

    # Diagnostics
    bind.dnsutils     # `dig` and `nslookup`
    curl
    wget
    mtr               # Enhanced traceroute
    traceroute
    nmap
    tcpdump
  ];
}
