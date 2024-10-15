# contains build functions for systems
{
  mkSystem =
    { configuration
    , home-configuration
    , specialArgs ? { }
    ,
    }: { };

  # the main function to declare new systems
  oldmkSystem =
    let
      hm-config = import ../modules/home-manager.nix;
      # create the user which should be used for updatse with `colmena`
      updater =
        { config, ... }:
        let
          username = "colmena";
        in
        {
          deployment.targetUser = username;

          users = {
            groups.${username} = { };
            users.${username} = {
              group = username;
              password = null;
              hashedPassword = null;
              hashedPasswordFile = null;
              openssh.authorizedKeys.keys = config.users.users.tornax.openssh.authorizedKeys.keys;
              isSystemUser = true;
            };
          };

          security.sudo-rs.extraRules = [
            {
              users = [ username ];
              commands = [
                {
                  command = "ALL";
                  options = [ "NOPASSWD" ];
                }
              ];
            }
          ];
        };
    in
    { configuration
    , home-configuration
    , deployment-conf ? { }
    }: { name, config, lib, ... }: {
      imports = [
        configuration
        (hm-config home-configuration)
        updater
      ];

      config.deployment = deployment-conf;
    };
}
