{ wg0, ... }:
{
  networking.wg-quick.interfaces.wg0 = {
    address = [ "${wg0.laptop.addr}/32" ];
    peers = [
      {
        publicKey = wg0.server.publicKey;
        allowedIPs = [ wg0.netmask ];
        endpoint = "${wg0.server.ip6}:${builtins.toString wg0.port}";
        persistentKeepalive = 30;
      }
    ];
  };
}
