{ config, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.overlays = [ (import ../overlays/tweaks.nix) ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  sops.secrets."forge/token" = {
    mode = "0440";
    group = "wheel";          # the daemon (root) and the machine's admins
  };

  programs.git = {
    enable = true;
    config = {
      credential."https://forge".username = "camille";
      credential."https://forge".helper =
        "!f() { [ \"$1\" = get ] && echo \"password=$(cat ${config.sops.secrets."forge/token".path})\"; }; f";
    };
  };
}
