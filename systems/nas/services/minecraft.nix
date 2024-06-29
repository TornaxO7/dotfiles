{ ... }:
{
  config = {
    virtualisation.oci-containers.minecraft = {
      image = "itzg/minecraft-server";
      ports = [ "8070:25565" ];
      environment = {
        EULA = "TRUE";
        FTB_MODPACK_ID = "120";
      };
    };
  };
}
