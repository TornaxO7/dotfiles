{ wg0, ... }:
{
  networking = {
    firewall.interfaces.ens3.allowedUDPPorts = [ wg0.port ];

    wg-quick.interfaces.wg0 = {
      address = [ "${wg0.server.addr}/32" ];
      listenPort = wg0.port;
      peers =
        let
          addPeer = peer: {
            publicKey = peer.publicKey;
            allowedIPs = [ "${peer.addr}/32" ];
          };
        in
        [
          (addPeer wg0.pc)
          (addPeer wg0.nas)
          (addPeer wg0.laptop)
          (addPeer wg0.mobile)
        ];
    };
  };
}
