{
  description = "Hyprland + Noctalia workstation with a secondary COSMIC session";

  # Matches the local nixpkgs revision used for evaluation. Advance deliberately.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/a32edd7654519351e48e80372a928df336394670";

  outputs = { nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
