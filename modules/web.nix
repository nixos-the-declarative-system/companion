{ lib, config, ... }:

{
  options.my.web.networkAccess =
    lib.mkEnableOption "publishing the site on the network";

  config = {
    services.nginx.enable = true;

    services.nginx.virtualHosts."localhost" = {
      root = "/srv/www";
    };

    networking.firewall.allowedTCPPorts =
      lib.mkIf config.my.web.networkAccess [ 80 ];
  };
}
