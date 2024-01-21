{ self, inputs, ... }:
{
  flake = {
    deploy = {
      nodes = {
        pc = {
          hostname = "localhost";
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib.${self.nixosConfigurations.laptop.pkgs.system}.activate.nixos self.nixosConfigurations.pc;
          };
        };

        laptop = {
          hostname = "laptop";
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib.${self.nixosConfigurations.laptop.pkgs.system}.activate.nixos self.nixosConfigurations.laptop;
          };
        };
      };
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
  };
}
