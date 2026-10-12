final: prev: {

  # the homemade package enters pkgs — its fix shipped
  tomate = (final.callPackage ../packages/tomate.nix { }).overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      (final.fetchpatch {
        url = "https://github.com/nixos-the-declarative-system/tomate/commit/5db8b17.patch";
        hash = "sha256-wzxQisC2rGj27aCn/mCWUZ+BUd666xTccBFAPirQ2e4=";
      })
    ];
  });

  # htop, moved forward one version
  htop = prev.htop.overrideAttrs (old: rec {
    version = "3.5.2";
    src = prev.fetchFromGitHub {
      owner = "htop-dev";  repo = "htop";
      tag = version;
      hash = "sha256-YKv0ski+lT4nMsGou0KmvXTbyG4DZYSq4+TU7Ts2qfo=";
    };
  });

  # ripgrep, moved forward one version — the second fingerprint served again
  ripgrep = prev.ripgrep.overrideAttrs (old: rec {
    version = "15.2.0";
    src = prev.fetchFromGitHub {
      owner = "BurntSushi";
      repo = "ripgrep";
      rev = version;
      hash = "sha256-BsSIbZwB6s8i3dDTRYJ1EdVbJmiO0oxcLu6qiYlPkOI=";
    };
    cargoDeps = prev.rustPlatform.fetchCargoVendor {
      inherit src;
      name = "ripgrep-${version}-vendor";
      hash = "sha256-AqizStE9ICd6mNDZWdeXg6dHuTiY+B0TNauQQYWUa84=";
    };
  });

  # sentinelle, the vendor's binary — repaired at build time
  sentinelle = final.callPackage ../packages/sentinelle.nix { };
  fhs = final.callPackage ../packages/fhs.nix { };
}
