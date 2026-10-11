{ ... }:

{
  imports = [
    ./hardware-configuration.nix        # does not exist yet
    ./disks.nix
    ../../modules/base.nix
    ../../modules/locale.nix
    ../../modules/users.nix
    ../../modules/tools.nix
    ../../modules/remote-access.nix
  ];

  networking.hostName = "granite";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  my.remoteAccess.enable = true;

  users.users.backup = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL5dYBdBDh/xOi7cL/wVgA4Z3zSYLYvnHPn59iV8927K backup@showcase"
    ];
  };

  sops.defaultSopsFile = ../../secrets/granite.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  system.stateVersion = "26.05";
}
