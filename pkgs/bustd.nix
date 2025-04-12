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

  cargoHash = "sha256-2HhgYkbn3hUlmwYXBOjNAs4w7e4a5UwKOHP5gRCArm8=";

  meta = {
    description = "Process killer daemon for out-of-memory scenarios";
    homepage = "https://github.com/vrmiguel/bustd";
    license = lib.licenses.mit;
    mainProgram = pname;
  };
}
