{ wg, ... }:
{
  networking.wg-quick.interfaces.wg0 = {
    address = [ "${wg.laptop.addr}/32" ];
    peers = [
      {
        publicKey = wg.server.publicKey;
        allowedIPs = [ wg.netmask ];
        endpoint = "${wg.domain}:${builtins.toString wg.port}";
        persistentKeepalive = 30;
      }
    ];
  };
}
