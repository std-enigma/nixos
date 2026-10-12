{ pkgs, ... }:
{
  hardware.graphics.enable = true;
  security.polkit.enable = true;
  security.rtkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;
  security.pam.services.login.enableGnomeKeyring = true;
  # Noctalia uses the existing login PAM stack for screen unlocking.
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.fstrim.enable = true;
  programs.dconf.enable = true;
  programs.firefox.enable = true;
  programs.thunar.enable = true;
  programs.xfconf.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    mousepad
    mpv
    imv
    zathura
    btop
    wl-clipboard
    brightnessctl
    playerctl
    libnotify
    xdg-utils
    xdg-user-dirs
    adwaita-icon-theme
    bibata-cursors
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [ inter noto-fonts noto-fonts-color-emoji nerd-fonts.jetbrains-mono ];
    fontconfig.defaultFonts = {
      sansSerif = [ "Inter" "Noto Sans" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "inode/directory" = "thunar.desktop";
      "text/plain" = "org.xfce.mousepad.desktop";
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "video/mp4" = "mpv.desktop";
    };
  };
}
