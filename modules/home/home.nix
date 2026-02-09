{ config, pkgs, ... }:

{
  home.username = "graeme";
  home.homeDirectory = "/home/graeme";

  # sops-nix configuration
  sops = {
    age.keyFile = "/home/graeme/.config/sops/age/keys.txt";
    defaultSopsFile = ../../secrets/secrets.yaml;

    secrets = {
      "ssh/id_rsa" = {
        path = "/home/graeme/.ssh/id_rsa";
        mode = "0600";
      };
      "ssh/id_rsa_pub" = {
        path = "/home/graeme/.ssh/id_rsa.pub";
        mode = "0644";
      };
      "aws/credentials" = {
        path = "/home/graeme/.aws/credentials";
        mode = "0600";
      };
      "npmrc" = {
        path = "/home/graeme/.npmrc";
        mode = "0600";
      };
    };
  };

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

  # Git configuration
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user.name = "Graeme Hill";
      user.email = "graemekh@gmail.com";
      core.editor = "nvim";
    };
  };

  # SSH agent (systemd user service)
  services.ssh-agent.enable = true;

  # Mako notification daemon
  services.mako = {
    enable = true;
    settings.default-timeout = 5000;  # 5 seconds
  };

  # Signal dark mode to GTK applications (Chrome, Firefox, etc.)
  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = true;
    };
  };

  # Force overwrite existing GTK config files
  xdg.configFile."gtk-3.0/settings.ini".force = true;
  xdg.configFile."gtk-4.0/settings.ini".force = true;

  # Signal dark mode via dconf (for apps that check this)
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Link dotfiles
  home.file = {
    ".config/hypr/hyprland.conf" = {
      source = ../../dotfiles/.config/hypr/hyprland.conf;
      force = true;
    };
    ".config/hypr/hyprlock.conf" = {
      source = ../../dotfiles/.config/hypr/hyprlock.conf;
      force = true;
    };
    ".config/hypr/hypridle.conf" = {
      source = ../../dotfiles/.config/hypr/hypridle.conf;
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
    ".config/nvim" = {
      source = ../../dotfiles/.config/nvim;
      recursive = true;
      force = true;
    };
  };
}
