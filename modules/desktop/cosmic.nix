{ lib, pkgs, ... }:
let
  screenshot = pkgs.writeShellApplication {
    name = "desktop-screenshot";
    runtimeInputs = with pkgs; [ grim slurp xdg-user-dirs coreutils ];
    text = ''
      region=$(slurp) || exit 0
      pictures=$(xdg-user-dir PICTURES)
      destination="$pictures/Screenshots"
      mkdir -p "$destination"
      grim -g "$region" "$destination/$(date +%Y-%m-%d_%H-%M-%S-%N).png"
    '';
  };
  shortcuts = pkgs.writeTextFile {
    name = "cosmic-shared-app-shortcuts";
    destination = "/share/cosmic/com.system76.CosmicSettings.Shortcuts/v1/custom";
    text = ''
      {
        (modifiers: [Super], key: "t"): Spawn("${pkgs.kitty}/bin/kitty"),
        (modifiers: [Super], key: "f"): Spawn("${pkgs.thunar}/bin/thunar"),
        (modifiers: [], key: "Print"): Spawn("${screenshot}/bin/desktop-screenshot"),
      }
    '';
  };
in
{
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = false;

  # Override only these shortcuts; keep the upstream window-management defaults.
  # A user's own COSMIC custom shortcut file still takes precedence.
  environment.systemPackages = [ (lib.hiPrio shortcuts) screenshot ];

  # Keep the compositor, shell, settings, files (desktop integration), and
  # cosmic-greeter (COSMIC's locker). Remove optional bundled applications.
  environment.cosmic.excludePackages = with pkgs; [
    cosmic-term
    cosmic-edit
    cosmic-store
    cosmic-monitor
    cosmic-player
    cosmic-reader
    cosmic-screenshot
    cosmic-wallpapers
  ] ++ lib.optional (pkgs ? cosmic-viewer) pkgs.cosmic-viewer;
}
