# Host-specific options that each host sets in its own default.nix
# Shared modules consume these via `config.myHost.*` (or `osConfig.myHost.*` in home-manager)

{ lib, pkgs, ... }:

{
  options.myHost = {
    monitorConfig = lib.mkOption {
      type = lib.types.str;
      description = "Hyprland monitor configuration";
      example = "monitor=,preferred,auto,1.5";
    };

    kbOptions = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "Keyboard options for Hyprland input config (e.g., caps:swapescape)";
      example = "caps:swapescape";
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
      description = "Host-specific packages to install";
      example = lib.literalExpression "[ pkgs.steam ]";
    };
  };
}
