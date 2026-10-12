# a pocket-sized conventional Linux
{ buildFHSEnv }:

buildFHSEnv {
  name = "fhs";
  targetPkgs = pkgs: with pkgs; [ openssl zlib icu ];
  runScript = "bash";
}
