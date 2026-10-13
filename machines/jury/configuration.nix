{ modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disks.nix
    ../../modules/base.nix
    ../../modules/locale.nix
    ../../modules/users.nix
    ../../modules/tools.nix
    ../../modules/remote-access.nix
    ../../modules/certificates.nix
  ];

  networking.hostName = "jury";
  networking.hosts."192.168.122.97" = [ "showcase" "forge" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  my.remoteAccess.enable = true;

  sops.defaultSopsFile = ../../secrets/jury.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  system.stateVersion = "26.05";
}
