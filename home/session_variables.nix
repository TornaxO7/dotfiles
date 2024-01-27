{ ... }:
{
  home.sessionVariables = {
    PATH = "$PATH:~/.local/bin";
    MOZ_USE_XINPUT2 = "1";
    DEEPL_AUTH_KEY = "$(cat /run/agenix/deepl)}";
  };
}
