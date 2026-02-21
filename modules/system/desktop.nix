# Desktop environment configuration
# Import this from hosts that need a GUI (not servers)

{ config, pkgs, ... }:

{
  # Display manager (SDDM is KDE's default; uses Breeze theme with Plasma)
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # KDE Plasma 6
  services.desktopManager.plasma6.enable = true;

  # Keyboard
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    options = config.myHost.kbOptions;
  };

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.fira-code
    nerd-fonts.departure-mono
    nerd-fonts.inconsolata
    nerd-fonts.ubuntu-sans
  ];

  # Desktop packages
  environment.systemPackages = with pkgs; [
    ghostty
    zed-editor
    slack
    mediawriter

    # Common desktop apps
    google-chrome
    bitwarden-desktop
    vlc
    obs-studio

    # Virtualization (GUI)
    spice-gtk
  ];
}
