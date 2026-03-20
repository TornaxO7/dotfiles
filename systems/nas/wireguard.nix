{ wg0, ... }:
{
  networking.wg-quick.interfaces.wg0 = {
    address = [ "${wg0.nas.addr}/32" ];
    mtu = 1400;
    peers = [
      {
        publicKey = wg0.server.publicKey;
        allowedIPs = [ wg0.netmask ];
        endpoint = "${wg0.server.ip4}:${builtins.toString wg0.port}";
        persistentKeepalive = 60;
      }
    ];
  };
}
