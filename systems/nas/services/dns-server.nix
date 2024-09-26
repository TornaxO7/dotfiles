port: { ip-addr, ... }:
{
  services.adguardhome = {
    inherit port;

    enable = true;

    settings = {
      filters = map (url: { enabled = true; url = url; }) [
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_9.txt" # The Big List of Hacked Malware Web Sites
        "https://adguardteam.github.io/HostlistsRegistry/assets/filter_11.txt" # malicious url blocklist
      ];
    };
  };
}
