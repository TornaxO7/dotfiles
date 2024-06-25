{ self, inputs, ... }:
{
  flake = {
    deploy = {
      user = "root";

      nodes = {
        pc = {
          hostname = "localhost";
          profiles.system = {
            path = inputs.deploy-rs.lib.${self.nixosConfigurations.pc.pkgs.system}.activate.nixos self.nixosConfigurations.pc;
          };
        };

        laptop = {
          hostname = "laptop";
          profiles.system = {
            path = inputs.deploy-rs.lib.${self.nixosConfigurations.laptop.pkgs.system}.activate.nixos self.nixosConfigurations.laptop;
          };
        };

        nas = {
          hostname = "nas";
          profiles.system = {
            path = inputs.deploy-rs.lib.${self.nixosConfigurations.nas.pkgs.system}.activate.nixos self.nixosConfigurations.nas;
          };
        };
      };
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
  };
}
