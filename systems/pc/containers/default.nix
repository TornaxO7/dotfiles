{ config, ... }:
{
  containers = {
    redox-os = (import ./redox.nix) { inherit config; };
    # paperless = (import ./paperless.nix) { inherit config; };
  };
}
