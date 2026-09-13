{ wg0, ... }:
{
  networking = {
    firewall.interfaces = {
      ens3.allowedUDPPorts = [ wg0.port ];
      wg0.allowedTCPPorts = [ 22 ];
    };

    wg-quick.interfaces.wg0 = {
      address = [ "${wg0.small.addr}/32" ];
      listenPort = wg0.port;
      peers = [
        {
          publicKey = wg0.pc.publicKey;
          allowedIPs = [
            "${wg0.pc.addr}/32"
          ];
        }
        {
          publicKey = wg0.laptop.publicKey;
          allowedIPs = [
            "${wg0.laptop.addr}/32"
          ];
        }
        {
          publicKey = wg0.mobile.publicKey;
          allowedIPs = [
            "${wg0.mobile.addr}/32"
          ];
        }
      ];
    };
  };
}
