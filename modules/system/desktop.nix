# Desktop environment configuration
# Import this from hosts that need a GUI (not servers)

{ config, pkgs, ... }:

{
  # Display manager (greeter runs on X11; Hyprland session is still Wayland)
  services.xserver.enable = true;
  services.displayManager.sddm = {
    enable = true;
    theme = "where_is_my_sddm_theme";
    extraPackages = with pkgs.kdePackages; [
      qt5compat
    ];
  };

  # Hyprland
  programs.hyprland.enable = true;

  # XDG portal (needed for screen sharing, file pickers, etc.)
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      hyprland = {
        default = [ "hyprland" "gtk" ];
        "org.freedesktop.impl.portal.Screenshot" = "hyprland";
        "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
      };
    };
  };

  # Keyboard
  services.xserver.xkb = {
    layout = "us";
    variant = "";
    # Note: caps/escape swap is handled per-host in Hyprland config (home.nix)
    # Desktop has hardware swap, zenbook/thinkpad use Hyprland kb_options
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
    where-is-my-sddm-theme
    ghostty
    zed-editor
    slack
    mediawriter

    # Hyprland ecosystem
    waybar
    wofi
    swww
    hyprlock
    hypridle
    hyprshot
    grim
    slurp
    wf-recorder
    wl-clipboard
    cliphist
    brightnessctl
    networkmanagerapplet
    blueman
    pavucontrol
    hyprmon

    # Common desktop apps
    google-chrome
    bitwarden-desktop
    vlc
    obs-studio

    # Virtualization (GUI)
    spice-gtk
  ];
}
