{ ... }:
{
  # Select backends per desktop; a global Hyprland override breaks COSMIC.
  xdg.portal.config = {
    hyprland = {
      default = [ "hyprland" "gtk" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
    cosmic = {
      default = [ "cosmic" "gtk" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };
  };
}
