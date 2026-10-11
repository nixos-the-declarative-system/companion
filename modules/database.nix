{ lib, config, ... }:

{
  options.my.database.networkAccess =
    lib.mkEnableOption "access to the database from the network";

  config = lib.mkMerge [
    {
      services.postgresql.enable = true;

      services.postgresql.ensureDatabases = [ "camille" ];
      services.postgresql.ensureUsers = [
        { name = "camille"; ensureDBOwnership = true; }
      ];
    }

    (lib.mkIf config.my.database.networkAccess {
      services.postgresql.enableTCPIP = true;
      services.postgresql.authentication = ''
        host all all 192.168.122.0/24 scram-sha-256
      '';
      networking.firewall.allowedTCPPorts = [ 5432 ];

      sops.secrets."db/camille".owner = "postgres";

      systemd.services.postgresql-setup.postStart = lib.mkAfter ''
        echo "ALTER ROLE camille PASSWORD '$(cat ${config.sops.secrets."db/camille".path})'" | psql --set ON_ERROR_STOP=1 -f -
      '';
    })
  ];
}
