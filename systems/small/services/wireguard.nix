{ wg0, ... }:
let
  mini =
    let
      mini-ips = import ../../mini/ips.nix;
      ip4 = mini-ips.ip4;
    in
    {
      publicKey = wg0.mini.publicKey;
      allowedIPs = [ wg0.netmask ];
      endpoint = "${ip4}:${builtins.toString wg0.port}";
    };
in
{
  services.openssh = {
    # openFirewall = false;
    settings.PasswordAuthentication = false;
  };

  networking = {
    firewall.interfaces = {
      ens3.allowedUDPPorts = [ wg0.port ];
      wg0.allowedTCPPorts = [ 22 ];
    };

    wg-quick.interfaces.wg0 = {
      address = [
        "${wg0.small.addr}/32"
      ];
      peers = [ mini ];
    };
  };
}

