{ config, lib, pkgs, ... }:

{
  # ---------------------------------------------------------
  # 1. Nixpkgs Configuration
  # ---------------------------------------------------------
  nixpkgs.config = {
    # Allow proprietary packages (e.g. Steam, Discord, NVIDIA, VSCode)
    allowUnfree = true;

    # Permit specific insecure packages only if absolutely required:
    # permittedInsecurePackages = [
    #   "openssl-1.1.1w"
    # ];
  };

  # ---------------------------------------------------------
  # 2. Nix Daemon & Engine Settings
  # ---------------------------------------------------------
  nix = {
    # Specify the Nix package implementation (lix or modern nixVersions)
    package = pkgs.nixVersions.latest;

    settings = {
      # Enable Flakes and the modern 'nix' CLI tool
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Sandboxing ensures package builds are isolated from the host system
      sandbox = true;

      # Users allowed to push to local caches or run privileged nix operations
      trusted-users = [
        "root"
        "@wheel" # All members of the wheel admin group
      ];

      # -------------------------------------------------------
      # Binary Caches & Substituters
      # -------------------------------------------------------
      # Downloads pre-built binaries instead of building from source
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org" # Uncomment if using Hyprland flake
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];

      # Performance & Concurrency
      max-jobs = "auto";       # Use all CPU threads for builds
      cores = 0;              # 0 tells builder threads to utilize all cores
      connect-timeout = 5;    # Timeout fast on unreachable caches
      warn-dirty = false;     # Suppress dirty git tree warnings with flakes

      # -------------------------------------------------------
      # Storage Optimization
      # -------------------------------------------------------
      # Deduplicate identical files across derivations using hard links
      auto-optimise-store = true;

      # Keep build-time dependencies around for nix-shell/nix develop environments
      keep-outputs = true;
      keep-derivations = true;
    };

    # ---------------------------------------------------------
    # 3. Automated Garbage Collection
    # ---------------------------------------------------------
    # Cleans up old system generations and unreferenced packages
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    # Periodically run store optimization (complements auto-optimise-store)
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
  };

  # ---------------------------------------------------------
  # 4. Useful Nix Developer & Inspection Tools
  # ---------------------------------------------------------
  environment.systemPackages = with pkgs; [
    nix-output-monitor # `nom` - pretty tree view for builds
    nvd                # Generation diff tool (shows package changes across rebuilds)
    nix-tree           # Interactive terminal viewer for store dependencies
    nix-prefetch-git   # Helper for calculating hashes
  ];
}
