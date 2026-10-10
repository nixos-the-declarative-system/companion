{ config, lib, pkgs, ... }:

{
  services.spice-vdagentd.enable = true;

  systemd.user.services.spice-vdagent-client = {
    description = "Spice guest session agent";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    unitConfig.StartLimitIntervalSec = 0;
    serviceConfig = {
      ExecStart = "${pkgs.spice-vdagent}/bin/spice-vdagent -x";
      Restart = "always";
      RestartSec = 2;
    };
  };

  # Wayland -> X11 clipboard bridge (Plasma guests)
  systemd.user.services.clipboard-wayland-to-x11 =
    lib.mkIf config.services.desktopManager.plasma6.enable {
      description = "Wayland -> X11 clipboard bridge for spice-vdagent";
      wantedBy = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      partOf = [ "graphical-session.target" ];
      unitConfig.StartLimitIntervalSec = 0;
      serviceConfig = {
        ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${
          pkgs.writeShellScript "clip-to-x11" ''
            # push only if the content changed: no bouncing
            content="$(cat)"
            state="$XDG_RUNTIME_DIR/clip-bridge-last"
            [ -f "$state" ] && [ "$content" = "$(cat "$state")" ] && exit 0
            printf %s "$content" > "$state"
            printf %s "$content" | ${pkgs.xclip}/bin/xclip -selection clipboard
          ''
        }";
        Restart = "always";
        RestartSec = 2;
      };
    };
}
