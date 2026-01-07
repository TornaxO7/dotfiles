{ wg, ... }:
{
  networking = {
    firewall.interfaces.ens3.allowedUDPPorts = [ wg.port ];

    wg-quick.interfaces.wg0 = {
      address = [ "${wg.server.addr}/32" ];
      listenPort = wg.port;
      peers =
        let
          addPeer = peer: {
            publicKey = peer.publicKey;
            allowedIPs = [ "${peer.addr}/32" ];
          };
        in
        [
          (addPeer wg.pc)
          (addPeer wg.nas)
          (addPeer wg.laptop)
          (addPeer wg.mobile)
        ];
    };
  };
}
