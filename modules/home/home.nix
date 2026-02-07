{ config, pkgs, ... }:

{
  home.username = "graeme";
  home.homeDirectory = "/home/graeme";

  home.stateVersion = "25.11";

  # Add scripts directory to PATH
  home.sessionPath = [
    "/home/graeme/nix-graeme/scripts"
  ];

  programs.home-manager.enable = true;

  # Bash configuration
  programs.bash = {
    enable = true;
    initExtra = ''
      eval "$(starship init bash)"
    '';
  };

  # Force overwrite existing files managed by programs.*
  home.file.".bashrc".force = true;

  # Starship prompt
  programs.starship = {
    enable = true;
  };

  # direnv for per-project dev environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # SSH agent (systemd user service)
  services.ssh-agent.enable = true;

  # Link dotfiles
  home.file = {
    ".config/hypr/hyprland.conf" = {
      source = ../../dotfiles/.config/hypr/hyprland.conf;
      force = true;
    };
    ".config/waybar/config.jsonc" = {
      source = ../../dotfiles/.config/waybar/config.jsonc;
      force = true;
    };
    ".config/waybar/style.css" = {
      source = ../../dotfiles/.config/waybar/style.css;
      force = true;
    };
    ".config/waybar/mocha.css" = {
      source = ../../dotfiles/.config/waybar/mocha.css;
      force = true;
    };
    ".config/ghostty/config" = {
      source = ../../dotfiles/.config/ghostty/config;
      force = true;
    };
  };
}
