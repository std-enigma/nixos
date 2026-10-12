{ config, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # Noctalia and COSMIC provide their own Bluetooth controls.
}
