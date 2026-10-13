{ config, pkgs, ... }:

{
  sops.secrets."runner/registration" = { };

  users.groups.runner = { };

  sops.templates."runner-netrc" = {
    content = ''
      machine forge
      login forgejo
      password ${config.sops.placeholder."forge/token"}
    '';
    group = "runner";
    mode = "0440";
  };

  systemd.tmpfiles.rules = [
    "L+ /var/lib/gitea-runner/jury/.netrc - - - - ${config.sops.templates."runner-netrc".path}"
  ];

  systemd.services.gitea-runner-jury.serviceConfig = {
    ExecPaths = [ "/var/lib/gitea-runner" ];
    SupplementaryGroups = [ "runner" ];
  };

  virtualisation.podman.enable = true;

  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances = {
      jury = {
        enable = true;
        name = "jury";
        url = "https://forge";
        tokenFile = config.sops.secrets."runner/registration".path;
        labels = [ "nixos:host" ];
        hostPackages = with pkgs; [
          bash coreutils curl gawk gitMinimal gnutar gzip
          nodejs wget nix
        ];
      };

      container = {
        enable = true;
        name = "jury-container";
        url = "https://forge";
        tokenFile = config.sops.secrets."runner/registration".path;
        labels = [ "ubuntu-latest:docker://ghcr.io/catthehacker/ubuntu:act-22.04" ];
        settings.container = {
          options = "--add-host=forge:192.168.122.97 -v /etc/ssl/certs/ca-certificates.crt:/etc/ssl/certs/ca-certificates.crt:ro";
          valid_volumes = [ "/etc/ssl/certs/ca-certificates.crt" ];
        };
      };
    };
  };
}
