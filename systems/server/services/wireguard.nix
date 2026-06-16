{ wg0, wg1, ... }:
{
  networking = {
    firewall.interfaces = {
      ens3.allowedUDPPorts = [ wg0.port ];
      wg0.allowedTCPPorts = [ 22 ];
    };

    wg-quick.interfaces.wg0 = {
      address = [ "${wg0.server.addr}/32" ];
      listenPort = wg0.port;
      peers = [
        {
          publicKey = wg0.pc.publicKey;
          allowedIPs = [
            "${wg0.pc.addr}/32"
            "${wg1.pc.addr}/32"
          ];
        }
        {
          publicKey = wg0.nas.publicKey;
          allowedIPs = [
            "${wg0.nas.addr}/32"
            "${wg1.nas.addr}/32"
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
            "${wg1.mobile.addr}/32"
          ];
        }
        {
          publicKey = wg1.ipad.publicKey;
          allowedIPs = [
            "${wg1.ipad.addr}/32"
          ];
        }
      ];
    };
  };
}
