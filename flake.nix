{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    # to get back the exact versions the book prints:
    # nixpkgs.url = "github:NixOS/nixpkgs/b3fe9581c9061c749abef42b6d4ee7b7c05c33fa";
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    site.url = "git+https://forge/camille/carnet.git";
    site.flake = false;
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, site, disko }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ (import ./overlays/tweaks.nix) ];
      };
    in {
      packages.x86_64-linux.tomate = pkgs.tomate;
      packages.x86_64-linux.my-blog = pkgs.callPackage ./packages/my-blog.nix { src = site; };

      nixosConfigurations.workshop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/workshop/configuration.nix
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
        ];
      };
      nixosConfigurations.showcase = nixpkgs.lib.nixosSystem {
        specialArgs = { my-blog = self.packages.x86_64-linux.my-blog; };
        system = "x86_64-linux";
        modules = [
          ./machines/showcase/configuration.nix
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
        ];
      };
      nixosConfigurations.trial = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/trial/configuration.nix
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
        ];
      };
      nixosConfigurations.granite = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./machines/granite/configuration.nix
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          sops-nix.nixosModules.sops
          { system.configurationRevision = self.rev or self.dirtyRev or null; }
        ];
      };

      checks.x86_64-linux = {
        web                = pkgs.testers.runNixOSTest ./tests/web.nix;
        web-network-access = pkgs.testers.runNixOSTest ./tests/web-network-access.nix;

        showcase-builds = self.nixosConfigurations.showcase.config.system.build.toplevel;
      };
    };
}
