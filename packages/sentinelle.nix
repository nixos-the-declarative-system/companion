{ stdenv, fetchurl, autoPatchelfHook, openssl, lib }:

stdenv.mkDerivation rec {
  pname = "sentinelle";
  version = "2.8.0";

  src = fetchurl {
    url = "https://github.com/nixos-the-declarative-system/sentinelle"
      + "/releases/download/v${version}/sentinelle-linux-x86_64.tar.gz";
    hash = "sha256-7XUnKyxmBLrvmQaM07+XMYgh6QUasZsdKSPdaycPJlQ=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ openssl stdenv.cc.cc.lib ];

  installPhase = ''
    runHook preInstall
    install -Dm755 sentinelle $out/bin/sentinelle
    runHook postInstall
  '';

  meta.license = lib.licenses.unfree;
}
