# NixOS workstation

The active entry point is `configuration.nix`. It imports the existing generated
hardware configuration and `modules/profiles/workstation.nix`. The flake exposes
one machine, `nixos`, using the existing `std-enigma` account and filesystem UUIDs.
`system.stateVersion` remains `26.05`.

## Desktop setup

- Noctalia Greeter handles login, with **Hyprland + Noctalia (UWSM)** selected by
  default. Choose **COSMIC** from the session picker for the secondary desktop.
- Noctalia starts only in the managed Hyprland session. COSMIC runs its own shell.
- PipeWire, Bluetooth, power profiles, keyring unlocking, removable-drive support,
  fonts, and separate Hyprland/COSMIC portal preferences are enabled.
- Shared apps: Kitty, Mousepad, Thunar, Firefox, mpv, imv, Zathura, and btop.
  MIME defaults select these apps where applicable. Existing per-user MIME
  preferences take precedence over system defaults.
- COSMIC defaults map Super+T to Kitty, Super+F to Thunar, and Print to a region
  screenshot saved in `Pictures/Screenshots`. Existing user-defined COSMIC
  custom shortcuts take precedence; adjust those in COSMIC Settings if present.
- Optional COSMIC terminal, editor, store, monitor, player, reader, screenshot
  utility, wallpapers, and viewer (when available) are excluded.
- COSMIC's greeter **service is disabled**. Its package remains because COSMIC
  uses it for locking. COSMIC Files, settings, and shell components also remain:
  nixpkgs lists them as core components required by the desktop. This is not a
  configuration that removes every package bearing the COSMIC name.

## Build and activate

Run from this directory on the target NixOS machine:

```sh
nix --extra-experimental-features 'nix-command flakes' flake lock "path:$PWD"
nix --extra-experimental-features 'nix-command flakes' build "path:$PWD#nixosConfigurations.nixos.config.system.build.toplevel"
sudo nixos-rebuild boot --flake "path:$PWD#nixos"
```

Reboot when ready to start the new greeter. `boot` leaves the running desktop
session alone. Select the previous generation in systemd-boot if needed.
The explicit `path:` reference includes the new files even before Git tracks them.
Keep the generated `flake.lock` with the configuration.

The input URL pins nixpkgs revision
`a32edd7654519351e48e80372a928df336394670`, matching the locally evaluated source
(Hyprland 0.56.2, Noctalia 5.1.0, Noctalia Greeter 1.5.0).
To update, change the revision or switch the input URL to
`github:NixOS/nixpkgs/nixos-unstable`, update the lock file, and build before activation.

## Everyday use

| Shortcut | Action |
| --- | --- |
| Super + Return | Kitty |
| Super + Space | Noctalia launcher |
| Super + E / B | Thunar / Firefox |
| Super + S | Control center |
| Super + comma | Noctalia settings |
| Super + L | Lock |
| Super + Q | Close window |
| Super + V | Toggle floating |
| Super + arrows | Focus direction |
| Super + 1–0 | Workspace 1–10 |
| Super + Shift + 1–0 | Move window to workspace |
| Super + mouse drag | Move (left button) / resize (right button) |
| Print | Region screenshot |
| Super + Shift + E | Log out |

Edit `config/hypr/hyprland.lua` for system defaults. It is installed at
`/etc/xdg/hypr/hyprland.lua`; the managed session explicitly loads it.
Optional personal overrides are loaded from `$XDG_CONFIG_HOME/hypr/local.lua`
(normally `~/.config/hypr/local.lua`). Existing `hyprland.conf` or `hyprland.lua`
files are not overwritten or loaded by this session. The ordinary Hyprland entries
remain available for those personal configurations.

Use Noctalia's settings for wallpaper, appearance, and idle behavior. Its own
locker handles lock-before-suspend; test lock/unlock and suspend/resume on the
actual hardware before relying on them. Bluetooth is available but not powered
on automatically at boot.

## Review notes and remaining choices

The original active configuration had no desktop integration. Most files under
`modules/desktop`, `modules/profiles`, and `hosts` were empty, while the core and
hardware modules were disconnected drafts. Only the workstation profile and its
imports are active now. `flake.nix.bak`, the empty laptop/desktop host templates,
and unused core/hardware modules remain as drafts, not supported flake outputs.

Do not bulk-import those drafts: `modules/core/users.nix` defines a different
account (`stdil`), the network draft opens SSH, and hardware drafts force driver
choices. The current setup preserves the original account, networking, boot
kernel choice, and disk configuration. The active cache list is simplified to
the official cache, and scheduled store optimisation and 30-day cleanup are added.

Useful next additions require machine-specific information: GPU/video decoding
configuration, monitor scaling/layout, a backup destination and retention policy,
and swap/hibernation sizing. There is no disk swap in the generated hardware file.
No hardware-specific module or SSH server has been enabled by this profile.

## Validation

The system configuration was evaluated against the local pinned revision with
no failed NixOS assertions or warnings, including the full system derivation.
Lua syntax was checked separately; this is
not a live Hyprland or greeter test.

The editing environment denies access to the Nix daemon and shell network, so
package builds, flake-lock generation, activation, and graphical runtime checks
could not be performed there. On the target machine, verify login into each
desktop, lock/unlock, suspend/resume, audio, Bluetooth, browser screen sharing,
file pickers, and that Noctalia exits when logging out of Hyprland.
