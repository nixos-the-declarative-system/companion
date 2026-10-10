{ stdenv, zola }:

stdenv.mkDerivation {
  pname = "my-blog";
  version = "1.0";

  src = ../site;   # no fetcher: a path in the repository is enough

  nativeBuildInputs = [ zola ];

  installPhase = ''
    zola build -o $out
  '';
}
