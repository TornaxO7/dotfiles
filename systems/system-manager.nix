{ config, ... }:
let
  username = "manager";
in
{
  users = {
    groups.${username} = { };
    users.${username} = {
      group = username;
      password = null;
      hashedPassword = null;
      hashedPasswordFile = null;
      openssh.authorizedKeys.keys = config.users.users.main.openssh.authorizedKeys.keys;
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
}
