{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.niri-screenshare;
in
{
  options.services.niri-screenshare = {
    enable = lib.mkEnableOption "the niri ScreenCast portal";

    withPicker = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Build the default package with the GTK display and window picker.";
    };

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix { inherit (cfg) withPicker; };
      defaultText = lib.literalExpression "pkgs.callPackage ./package.nix { inherit (cfg) withPicker; }";
      description = "The niri-screenshare package to use.";
    };
  };

  config = lib.mkIf cfg.enable {
    xdg.portal = {
      enable = true;
      extraPortals = [ cfg.package ];
      config.niri."org.freedesktop.impl.portal.ScreenCast" = "niri";
    };

    systemd.user.services.niri-screenshare = {
      enableDefaultPath = false;
      environment.NIRI_SCREENSHARE_NO_PORTAL_CONFIG = "1";
    };
  };
}
