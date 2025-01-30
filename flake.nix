{
  description = "NixOS Flake config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprpaper.url = "github:hyprwm/hyprpaper?submodules=1";
    hypridle.url = "github:hyprwm/hypridle?submodules=1";
    hyprlock.url = "github:hyprwm/hyprlock?submodules=1";
    hyprpicker.url = "github:hyprwm/hyprpicker?submodules=1";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
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
