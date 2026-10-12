{ ... }:
{
  imports = [
    ../desktop/common.nix
    ../desktop/hyprland.nix
    ../desktop/cosmic.nix
    ../desktop/display-manager.nix
    ../desktop/xdg-portal.nix
    ../services/audio.nix
    ../services/bluetooth.nix
    ../services/power.nix
  ];
}
