{ config, pkgs, ... }:

{
  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # System packages
  environment.systemPackages = with pkgs; [
    git
    ghostty
    google-chrome
    zed-editor
    bitwarden-cli
    bitwarden-desktop
    neovim
    gcc
    tree-sitter
    jq
    claude-code
    tree
    starship
    lazygit
    gitui
    tig
    ripgrep
    btop
    slack
    slack-cli
    slack-term
    ncdu
    mediawriter
    bluetui
    unzip
    git-lfs
    vifm

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

    # Virtualization
    spice-gtk  # Better clipboard/USB support in VMs
  ];
}
