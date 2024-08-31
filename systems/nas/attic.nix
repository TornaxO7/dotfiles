port: { config, inputs, ... }:
let
  portStr = toString port;
in
{
  imports = [
    inputs.attic.nixosModules.atticd
  ];

  config = {
    services.atticd = {
      enable = true;

      credentialsFile = config.age.secrets.atticd.path;

      settings = {
        listen = "[::]:${portStr}";
        chunking = {
          # The minimum NAR size to trigger chunking
          #
          # If 0, chunking is disabled entirely for newly-uploaded NARs.
          # If 1, all NARs are chunked.
          nar-size-threshold = 64 * 1024; # 64 KiB

          # The preferred minimum size of a chunk, in bytes
          min-size = 16 * 1024; # 16 KiB

          # The preferred average size of a chunk, in bytes
          avg-size = 64 * 1024; # 64 KiB

          # The preferred maximum size of a chunk, in bytes
          max-size = 256 * 1024; # 256 KiB
        };
      };
    };
  };
}
