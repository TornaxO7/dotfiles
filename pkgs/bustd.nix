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
    rev = "v${version}";
    hash = "sha256-UmigoFWaF/+lSUKv0DZFL4BRW69tayfzs7rkI3tUrAc=";
  };

  cargoHash = "sha256-75OqHACEUiwdboIHAdvLTSISUzSbRvxw1sBdLyldJe8=";

  meta = {
    description = "Process killer daemon for out-of-memory scenarios";
    homepage = "https://github.com/vrmiguel/bustd";
    license = lib.licenses.mit;
    mainProgram = pname;
  };
}
