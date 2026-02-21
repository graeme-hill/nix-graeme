{ config, pkgs, osConfig, ... }:

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
      "anthropic_api_key" = {
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

      # Export secrets as environment variables
      if [ -r "${config.sops.secrets."anthropic_api_key".path}" ]; then
        export ANTHROPIC_API_KEY="$(cat ${config.sops.secrets."anthropic_api_key".path})"
      fi
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

  # Cursor theme
  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.adwaita-icon-theme;
    size = 24;
    gtk.enable = true;
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk2.force = true;
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
    ".config/ghostty/config" = {
      source = ../../dotfiles/.config/ghostty/config;
      force = true;
    };
    ".config/nvim" = {
      source = ../../dotfiles/.config/nvim;
      recursive = true;
      force = true;
    };
    ".config/tmux/tmux.conf" = {
      source = ../../dotfiles/.config/tmux/tmux.conf;
      force = true;
    };
  };
}
