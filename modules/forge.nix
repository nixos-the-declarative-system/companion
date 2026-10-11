{ config, ... }:

{
  services.forgejo = {
    enable = true;

    database.type = "postgres";   # the previous chapter's database — joined over the socket: same machine, zero secret

    settings = {
      server = {
        DOMAIN = "forge";
        ROOT_URL = "https://forge/";
        HTTP_ADDR = "127.0.0.1";  # the forge listens only at home — nginx exposes
        HTTP_PORT = 3000;
      };
      service.DISABLE_REGISTRATION = true;   # private forge: registration closed
    };
  };

  sops.secrets."forge/tls-key".owner = "nginx";

  services.nginx.virtualHosts."forge" = {
    forceSSL = true;
    sslCertificate = ../certificates/forge.pem;   # public — it lives in the repository, like the authority
    sslCertificateKey = config.sops.secrets."forge/tls-key".path;
    locations."/".proxyPass = "http://127.0.0.1:3000";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];   # 80 now only serves to redirect
}
