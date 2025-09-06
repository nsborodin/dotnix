{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      plugin-onedark.url = "github:navarasu/onedark.nvim";
      plugin-onedark.flake = false;
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
         {                                                        
              nixpkgs.overlays = [                                    
                (final: prev: {                                       
                  tailscale = prev.tailscale.overrideAttrs (_: { doCheck = false; });                                                                             })                                                    
                ];                                                      
         }    
        ./configuration.nix
         #https://www.reddit.com/r/NixOS/comments/196tksr/comment/khwzite/
         inputs.home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
           # home-manager.extraSpecialArgs = specialArgs;
         }
      ];
    };
  };
}
