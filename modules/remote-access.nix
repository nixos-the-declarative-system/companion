{ lib, config, ... }:

{
  options.my.remoteAccess.enable =
    lib.mkEnableOption "SSH access to the workstation";

  config = lib.mkIf config.my.remoteAccess.enable {
    services.openssh.enable = true;
  };
}
