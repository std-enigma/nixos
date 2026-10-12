{ ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
    # Started by Hyprland only, never over the COSMIC shell.
    systemd.enable = false;
  };

  # A dedicated session uses the managed config without overwriting dotfiles.
  programs.uwsm.waylandCompositors.hyprland-noctalia = {
    prettyName = "Hyprland + Noctalia";
    binPath = "/run/current-system/sw/bin/Hyprland";
    extraArgs = [ "--config" "/etc/xdg/hypr/hyprland.lua" ];
  };
  environment.etc."xdg/hypr/hyprland.lua".source = ../../config/hypr/hyprland.lua;
}
