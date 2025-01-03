{ wireguard, pkgs, ... }:
let
  externalInterface = "ens3";
in
{

  networking = {
    nat = {
      enable = true;
      externalInterface = externalInterface;
      internalInterfaces = [ "wg0" ];
    };

    firewall = {
      allowedUDPPorts = [ 51820 ];
    };

    wireguard = {
      enable = true;
      interfaces = {
        wg0 = {
          ips = [ "${wireguard.server}/24" ];

          listenPort = 51820;

          postSetup = ''
            ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.0.0.0/24 -o ${externalInterface} -j MASQUERADE
          '';

          postShutdown = ''
            ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.0.0.0/24 -o ${externalInterface} -j MASQUERADE
          '';

          privateKeyFile = "/etc/wireguard/private";
          generatePrivateKeyFile = true;

          peers = [
            {
              name = "pc";
              publicKey = "vnFCOf/HL53cL5Yfih/IjV/ZxjWhE0ENZwtoMkasnVA=";
              allowedIPs = [ "${wireguard.pc}/32" ];
            }
            {
              name = "laptop";
              publicKey = "QmRFcsCWjjxyb93D5iA79XPhmfOh/p2xR2at+yb9/FE=";
              allowedIPs = [ "${wireguard.laptop}/32" ];
            }
            {
              name = "nas";
              publicKey = "Y4HjCltHlLlAzmHUubwkZiurZLxPEEiZKPkPcWOj3n8=";
              allowedIPs = [ "${wireguard.nas}/32" ];
            }
            # {
            #   name = "mobile";
            #   publicKey = "";
            #   allowedIPs = [ "${wireguard.mobile}/32" ];
            # }
          ];
        };
      };
    };
  };
}
