{ config, lib, pkgs, ... }:

{
  fonts = {
    # Enable font discovery and fontconfig cache generation
    enableDefaultPackages = true;

    packages = with pkgs; [
      # -------------------------------------------------------
      # 1. UI & General Reading Fonts (Sans / Serif)
      # -------------------------------------------------------
      inter                  # Modern, clean UI font
      roboto
      noto-fonts             # Broad global coverage
      libertine              # High-quality serif font

      # -------------------------------------------------------
      # 2. Monospace & Developer Fonts (Nerd Fonts)
      # -------------------------------------------------------
      # Starting with NixOS 25.05 / recent unstable, use nerd-fonts.<name>
      # (Avoid installing `nerdfonts` whole suite; it is >3GB)
      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.hack
      nerd-fonts.symbols-only # Useful fallback for standalone glyphs

      # -------------------------------------------------------
      # 3. Emojis & International Coverage
      # -------------------------------------------------------
      noto-fonts-emoji       # Full color emojis
      noto-fonts-cjk-sans    # Chinese, Japanese, Korean (UI)
      noto-fonts-cjk-serif   # Chinese, Japanese, Korean (Serif)

      # -------------------------------------------------------
      # 4. Microsoft Compatibility (Uncomment if needed)
      # -------------------------------------------------------
      corefonts            # Arial, Times New Roman, Comic Sans, etc.
    ];

    # ---------------------------------------------------------
    # Fontconfig Configuration & Fallbacks
    # ---------------------------------------------------------
    fontconfig = {
      enable = true;

      # Rendering quality improvements
      antialias = true;
      hinting = {
        enable = true;
        style = "slight"; # "slight" provides the most natural letter shapes on modern displays
      };
      subpixel = {
        rgba = "rgb";     # Match standard LCD pixel layout
        lcdfilter = "default";
      };

      # Set system-wide default fallbacks for apps & web browsers
      defaultFonts = {
        serif = [
          "Linux Libertine"
          "Noto Serif"
          "Noto Color Emoji"
        ];
        sansSerif = [
          "Inter"
          "Noto Sans"
          "Noto Color Emoji"
        ];
        monospace = [
          "JetBrainsMono Nerd Font"
          "FiraCode Nerd Font"
          "Noto Color Emoji"
        ];
        emoji = [
          "Noto Color Emoji"
        ];
      };
    };
  };
}
