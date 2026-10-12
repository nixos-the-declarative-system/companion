{ config, pkgs, my-blog, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disks.nix
    ../../modules/base.nix
    ../../modules/locale.nix
    ../../modules/users.nix
    ../../modules/tools.nix
    ../../modules/remote-access.nix
    ../../modules/web.nix
    ../../modules/database.nix
    ../../modules/forge.nix
    ../../modules/certificates.nix
  ];

  networking.hostName = "showcase";
  networking.hosts."192.168.122.33" = [ "workshop" ];
  networking.hosts."127.0.0.1" = [ "forge" ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  my.remoteAccess.enable = true;
  my.web.networkAccess = true;
  my.database.networkAccess = true;

  services.postgresqlBackup = {
    enable = true;
    databases = [ "camille" "forgejo" ];
  };

  sops.secrets."backup/password" = { };
  sops.secrets."backup/ssh-key" = { };

  networking.hosts."192.168.122.62" = [ "granite" ];

  programs.ssh.knownHosts."granite".publicKey =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJzUvhaIR7xx0E3KN9MoFvgIDsCoy4kZePCtCkFzbNpQ";

  services.restic.backups.daily = {
    repository = "sftp:backup@granite:showcase";
    passwordFile = config.sops.secrets."backup/password".path;
    extraOptions = [
      "sftp.command='ssh backup@granite -i ${config.sops.secrets."backup/ssh-key".path} -s sftp'"
    ];
    paths = [ "/srv/www" "/var/backup/postgresql" "/var/lib/forgejo" ];
    timerConfig = { OnCalendar = "02:30"; };
    initialize = true;
  };

  services.nginx.virtualHosts."localhost".root =
    "${my-blog}";

  sops.defaultSopsFile = ../../secrets/showcase.yaml;
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  virtualisation.oci-containers.containers.sentinelle = {
    image = "localhost/sentinelle-agent:3.0";
    imageFile = pkgs.fetchurl {
      url = "https://github.com/nixos-the-declarative-system/sentinelle"
        + "/releases/download/agent-3.0/sentinelle-agent-3.0.tar";
      hash = "sha256-3R5Brfw/TxI6gfT6xWevJAW+7HYWJf75DKmsqMo3GHo=";
    };
    cmd = [ "forge" ];
  };

  system.stateVersion = "26.05";
}
