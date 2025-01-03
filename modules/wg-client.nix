{ ip-addr, ... }:
{
  # networking = {
  #   firewall.allowedUDPPorts = [ 51820 ];
  #   wireguard = {
  #     enable = true;
  #     interfaces = {
  #       wg0 = {
  #         ips = [ "${ip-addr}/24" ];
  #         listenPort = 51820;
  #         privateKeyFile = "/etc/wireguard/private";
  #         generatePrivateKeyFile = true;

  #         peers = [
  #           {
  #             name = "server";
  #             publicKey = "Sp+GoX7YlHcdxXFX40GvWKWA/Hm6FFfmzI5CgNvsxBk=";
  #             allowedIPs = [ "10.0.0.0/24" ];
  #             endpoint = "2.56.97.207:51820";
  #             persistentKeepalive = 25;
  #           }
  #         ];
  #       };
  #     };
  #   };
  # };
}
