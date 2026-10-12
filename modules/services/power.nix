{ config, pkgs, ... }:

{
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;
  # CPU-specific thermal daemons belong in a verified hardware profile.
}
