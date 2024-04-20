{ rustPlatform
, lib
, fetchFromGitHub
, ...
}: rustPlatform.buildRustPackage rec
{
  pname = "bustd";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "vrmiguel";
    repo = "bustd";
    rev = "5cf0867";
    hash = "sha256-STyPsfJTpJqucOvoUmBYz38sZmlJCLMt81/8/8akzgQ=";
  };

  cargoHash = "sha256-Gb6DXww/9mapmLAQBe7zgjkeluxszPLfuE7/enAtA7U=";

  meta = {
    description = "Process killer daemon for out-of-memory scenarios";
    homepage = "https://github.com/vrmiguel/bustd";
    license = lib.licenses.mit;
    mainProgram = pname;
  };
}
