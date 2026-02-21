# Host-specific options that each host sets in its own default.nix
# Shared modules consume these via `config.myHost.*` (or `osConfig.myHost.*` in home-manager)

{ lib, pkgs, ... }:

{
  options.myHost = {
    kbOptions = lib.mkOption {
      type = lib.types.str;
      default = "";
      description = "XKB keyboard options (e.g., caps:swapescape)";
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
