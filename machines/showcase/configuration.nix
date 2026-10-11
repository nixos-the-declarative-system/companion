{
  imports = [
    ./hardware-configuration.nix        # does not exist yet — the body will supply it
    ../../modules/base.nix
    ../../modules/locale.nix
    ../../modules/users.nix
    ../../modules/tools.nix
    ../../modules/remote-access.nix
    ../../modules/web.nix
    ../../modules/database.nix
    ../../modules/forge.nix
  ];

  networking.hostName = "showcase";
  networking.hosts."192.168.122.33" = [ "workshop" ];
  networking.hosts."127.0.0.1" = [ "forge" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  swapDevices = [{
    device = "/dev/disk/by-partlabel/swap";  # nor does it — the body will dig it
    randomEncryption.enable = true;
  }];

  my.remoteAccess.enable = true;
  my.web.networkAccess = true;
  my.database.networkAccess = true;

  sops.defaultSopsFile = ../../secrets/showcase.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  system.stateVersion = "26.05";
}
