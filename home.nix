{ pkgs, ... }:

{
  home.packages = with pkgs; [
    ripgrep   # yours, without the line saying so
    fd
    jq
    tree
    tomate    # a citizen in its own right
  ];

  programs.git = {
    enable = true;
    package = pkgs.git.override { withLibsecret = true; };
    settings = {
      user.name  = "Camille";
      user.email = "camille@example.org";
      alias.st = "status";
      init.defaultBranch = "main";
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -lh";
      gs = "git status";
    };
    history.size = 50000;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      clock-show-weekday = true;
    };
  };

  home.stateVersion = "26.05";
}
