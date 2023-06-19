{config, pkgs, lib, ...}:
{
  config = {
    services.openvpn.servers = {
      kit = {
        config = ''
          # config file version 2.5-1
          client
          remote 141.52.8.20
          port 1194
          dev tun
          proto udp
          auth-user-pass
          nobind
          # use tls-ciphersuite and tls-cipher default
          # tls-version-min is needed to fend off downgrade attack
          tls-version-min 1.2
          ca /etc/ssl/certs/ca-certificates.crt
          verify-x509-name ovpn.scc.kit.edu name
          cipher AES-256-GCM
          auth none
          # uncomment to avoid link-mtu and comp-lzo warnings. but be aware that
          # this option won't be supported anymore with next major openvpn release.
          #comp-lzo no
          verb 3
          script-security 2
        '';
      };
    };
  };
}
