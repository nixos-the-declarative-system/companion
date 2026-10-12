{ stdenv, fetchFromGitHub, lib }:

stdenv.mkDerivation {
  pname = "tomate";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "nixos-the-declarative-system";
    repo = "tomate";
    rev = "v1.2.1";
    hash = "sha256-buNZm0Su0vcdO2OT6krLXIDpAc7MHcy6cQSuHtjWEQQ=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "A Pomodoro timer for the terminal";
    homepage = "https://github.com/nixos-the-declarative-system/tomate";
    license = lib.licenses.mit;
  };
}
