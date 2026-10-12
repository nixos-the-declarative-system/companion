{ modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
  ];

  networking.hostName = "rescue";
  console.keyMap = "us";

  # camille's key opens the door — no more sudo passwd in an emergency
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGR20gP3lL9+ejOufur768JKRqlgCvQnad8qkKCGHa5v camille@workshop"
  ];
}
