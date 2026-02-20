{ config, pkgs, ... }:

{
  # System packages (shared + host-specific)
  environment.systemPackages = with pkgs; [
    git
    bitwarden-cli
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
    slack-cli
    slack-term
    ncdu
    bluetui
    unzip
    git-lfs
    vifm
    nodejs
    tmux
  ] ++ config.myHost.packages;
}
