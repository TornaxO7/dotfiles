{ ... }: {
  config.services.meilisearch = {
    enable = true;
    listenAddress = "127.0.0.1";
    listenPort = 49201;
  };
}
