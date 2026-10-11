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

  home.stateVersion = "26.05";
}
