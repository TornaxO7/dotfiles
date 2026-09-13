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

  small =
    let
      small-ips = import ../small/ips.nix;
      ip4 = small-ips.ip4;
    in
    {

      publicKey = wg0.small.publicKey;
      allowedIPs = [ wg0.small.addr ];
      endpoint = "${ip4}:${builtins.toString wg0.port}";
      persistentKeepalive = 30;
    };

  big =
    let
      big-ips = import ../big/ips.nix;
      ip4 = big-ips.ip4;
    in
    {

      publicKey = wg0.big.publicKey;
      allowedIPs = [ wg0.big.addr ];
      endpoint = "${ip4}:${builtins.toString wg0.port}";
      persistentKeepalive = 30;
    };
in
{
  networking = {
    wg-quick.interfaces.wg0 = {
      dns = [ wg0.mini.addr ];
      address = [ "${wg0.pc.addr}/32" ];
      mtu = 1400;
      peers = [ mini small big ];
    };
  };
}
