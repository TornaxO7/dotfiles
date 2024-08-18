{ rustPlatform
, lib
, fetchFromGitHub
, pkg-config
, openssl
, ...
}: rustPlatform.buildRustPackage rec
{
  pname = "crates-tui";
  version = "v0.1.7";

  src = fetchFromGitHub {
    owner = "ratatui-org";
    repo = pname;
    rev = "f2c738b";
    hash = "sha256-h7LFmuWx7f7fdFK7RpGxTYOtZ+eLk+k9x/OwJLegxic=";
  };

  cargoHash = "sha256-xLdwrUqFVwgjAs75vN2IEOQUB7cEi9GMkqExv6mc4L4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  meta = {
    description = " A TUI for exploring crates.io using Ratatui ";
    homepage = "https://github.com/ratatui-org/crates-tui";
    license = lib.licenses.mit;
    mainProgram = pname;
  };
}
