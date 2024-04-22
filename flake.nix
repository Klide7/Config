{
  inputs = {
    aquaris.url = "github:42loco42/aquaris";
    aquaris.inputs.home-manager.follows = "home-manager";
    aquaris.inputs.nixpkgs.follows = "nixpkgs";
    aquaris.inputs.obscura.follows = "obscura";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    obscura.url = "github:42loco42/obscura";
    obscura.inputs.nce.follows = "";
    obscura.inputs.nsc.follows = "";
  };

  outputs = { self, aquaris, ... }:
    let
      users = {
        "klide" = {
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBw2YXPlwLeWPqiPEptB2a0p4t8o140rJoOWPNJt1bYP";
          extraKeys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJVieLCkWGImVI9c7D0Z0qRxBAKf0eaQWUfMn0uyM/Ql"
          ];

          # git = {
          #   name = "";
          #   email = "";
          #   key = "";
          # }
        };
      };
      machines = {
        "nixos" = {
          id = "3e1d76f72b104d0287e1fbfa2a6f8048";
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMfCULMBZga2fI+oaFxf7mOuIxCmpbnRLZ49s+69rKtf";
          admins = { inherit (users) "klide"; };
          users = { };
        };
      };
    in
    aquaris.lib.main self { inherit users machines; };
}
