{ wg0, ... }:
let
  mini =
    let
      mini-ips = import ../mini/ips.nix;
      ip4 = mini-ips.ip4;
    in
    {
      publicKey = wg0.mini.publicKey;
      allowedIPs = [ wg0.netmask ];
      endpoint = "${ip4}:${builtins.toString wg0.port}";
      persistentKeepalive = 30;
    };
in
{
  networking.wg-quick.interfaces.wg0 = {
    dns = [ wg0.mini.addr ];
    address = [ "${wg0.nas.addr}/32" ];
    mtu = 1400;
    peers = [ mini ];
  };
}
