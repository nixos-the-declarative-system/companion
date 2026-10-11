{ lib, config, ... }:

{
  options.my.remoteAccess.enable =
    lib.mkEnableOption "SSH access to the workstation";

  config = lib.mkIf config.my.remoteAccess.enable {
    services.openssh.enable = true;

    services.openssh.settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };

    users.users.camille.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGR20gP3lL9+ejOufur768JKRqlgCvQnad8qkKCGHa5v camille@workshop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAshPndXpdyRZwBw6DySnwnYWOPws8/SRTwRbm9qVG3Y camille@showcase"
    ];
    # the key of YOUR workshop: nix key generate-secret draws a unique pair
    nix.settings.trusted-public-keys =
      [ "workshop-1:UuBW2pdcU4OdqODwos7WmuR6zKB2i2nAkkcGGn91Jk4=" ];
  };
}
