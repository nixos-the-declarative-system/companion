{ ... }:
{
  name = "web-network-access";

  nodes = {
    opened = {
      imports = [ ../modules/web.nix ];
      my.web.networkAccess = true;
    };
    closed = {
      imports = [ ../modules/web.nix ];
    };
    witness = { pkgs, ... }: {
      environment.systemPackages = [ pkgs.curl ];
    };
  };

  testScript = ''
    start_all()
    opened.wait_for_unit("nginx.service")
    closed.wait_for_unit("nginx.service")

    opened.succeed("mkdir -p /srv/www && echo opened > /srv/www/index.html")
    closed.succeed("mkdir -p /srv/www && echo closed > /srv/www/index.html")

    witness.succeed("curl --fail --max-time 5 http://opened/")
    witness.fail("curl --fail --max-time 5 http://closed/")
  '';
}
