{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation {
  pname = "tomate";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "nixos-the-declarative-system";
    repo = "tomate";
    rev = "v1.2.0";
    hash = "sha256-3Wx5Xhi1DoCym0SWxshBdC00l7wu8ESblgGkzQweLC4=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "A Pomodoro timer for the terminal";
    homepage = "https://github.com/nixos-the-declarative-system/tomate";
    license = lib.licenses.mit;
  };
}
