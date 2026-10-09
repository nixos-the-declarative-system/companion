{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/locale.nix
    ./modules/users.nix
    ./modules/tools.nix
    ./modules/remote-access.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # The kernel
  boot.kernelPackages = pkgs.linuxPackages;          # the LTS — the default value
  # boot.kernelPackages = pkgs.linuxPackages_latest; # the latest stable, for hardware too new

  # Identity
  networking.hostName = "workshop";
  networking.networkmanager.enable = true;

  # Remote access
  my.remoteAccess.enable = true;

  # Swap, declared: a fresh key at every boot
  swapDevices = [{
    device = "/dev/disk/by-partlabel/swap";
    randomEncryption.enable = true;
  }];

  system.stateVersion = "26.05";  # (already present) — will never change again — see the box
}
