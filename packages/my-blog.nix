{ stdenv, zola, src }:

stdenv.mkDerivation {
  pname = "my-blog";
  version = "1.0";

  inherit src;

  nativeBuildInputs = [ zola ];

  installPhase = ''
    zola build -o $out
  '';
}
