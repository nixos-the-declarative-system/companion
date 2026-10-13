{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/base.nix
    ../../modules/locale.nix
    ../../modules/users.nix
    ../../modules/tools.nix
    ../../modules/remote-access.nix
    ../../modules/web.nix
    ../../modules/database.nix
    ../../modules/desktop.nix
    ../../modules/virtual-machine.nix
    ../../modules/certificates.nix
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
  networking.hosts."192.168.122.97" = [ "showcase" "forge" ];
  networking.hosts."192.168.122.62" = [ "granite" ];
  networking.hosts."192.168.122.98" = [ "jury" ];

  sops.defaultSopsFile = ../../secrets/workshop.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  sops.secrets."nix/signing-key" = { };

  nix.settings.secret-key-files =
    [ config.sops.secrets."nix/signing-key".path ];

  sops.secrets."backup/password" = { };
  sops.secrets."backup/ssh-key" = { };

  programs.ssh.knownHosts."granite".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJzUvhaIR7xx0E3KN9MoFvgIDsCoy4kZePCtCkFzbNpQ";

  services.restic.backups.daily = {
    repository = "sftp:backup@granite:workshop";
    passwordFile = config.sops.secrets."backup/password".path;
    extraOptions = [
      "sftp.command='ssh backup@granite -i ${config.sops.secrets."backup/ssh-key".path} -s sftp'"
    ];
    paths = [ "/home/camille" ];
    exclude = [
      "/home/camille/.ssh"
      "/home/camille/.config/sops"
      "/home/camille/.cache"
    ];
    timerConfig = { OnCalendar = "02:30"; };
    initialize = true;
  };

  # Remote access
  my.remoteAccess.enable = true;

  # Swap, declared: a fresh key at every boot
  swapDevices = [{
    device = "/dev/disk/by-partlabel/swap";
    randomEncryption.enable = true;
  }];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [   # a starter kit
    stdenv.cc.cc.lib   # libstdc++, libgcc_s — the #1 request
    openssl            # TLS — sentinelle asked you for it
    zlib               # compression — the other ubiquitous one
  ];

  virtualisation.podman.enable = true;

  virtualisation.vmVariant = {
    virtualisation.memorySize = 4096;
    users.users.camille = {
      hashedPasswordFile = lib.mkForce null;
      password = "draft";
    };
  };

  system.stateVersion = "26.05";  # (already present) — will never change again — see the box
}
