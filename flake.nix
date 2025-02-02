{
  description = "NixOS Flake config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpolkitagent = {
      url = "github:hyprwm/hyprpolkitagent?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprpaper?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpicker = {
      url = "github:hyprwm/hyprpicker?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # helmwave = {
    #   url = "github:helmwave/nur";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = { nixpkgs, ... }@inputs: {
    nixosConfigurations.default = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
  };
}
