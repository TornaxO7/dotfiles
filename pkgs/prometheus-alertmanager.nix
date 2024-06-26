{ lib
, go
, buildGoModule
, fetchFromGitHub
, installShellFiles
}:

buildGoModule rec {
  pname = "alertmanager";
  version = "0.27.0";
  rev = "v${version}";

  src = fetchFromGitHub {
    owner = "prometheus";
    repo = "alertmanager";
    hash = "sha256-hox7e3rrFSkiu8HODUBcV35PmsY1Q+4o9z0fP2ugW4M=";
    rev = "4c1a187fef2597c173c6b91c50e4f40b295294b1"; # see https://github.com/prometheus/alertmanager/issues/3894
  };

  vendorHash = "sha256-H07IhDnIpCqhpCD9jreivFsIEUvMahYKLbAV7I8pnNk=";

  subPackages = [ "cmd/alertmanager" "cmd/amtool" ];

  ldflags = let t = "github.com/prometheus/common/version"; in [
    "-X ${t}.Version=${version}"
    "-X ${t}.Revision=${src.rev}"
    "-X ${t}.Branch=unknown"
    "-X ${t}.BuildUser=nix@nixpkgs"
    "-X ${t}.BuildDate=unknown"
    "-X ${t}.GoVersion=${lib.getVersion go}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    $out/bin/amtool --completion-script-bash > amtool.bash
    installShellCompletion amtool.bash
    $out/bin/amtool --completion-script-zsh > amtool.zsh
    installShellCompletion amtool.zsh
  '';

  meta = with lib; {
    description = "Alert dispatcher for the Prometheus monitoring system";
    homepage = "https://github.com/prometheus/alertmanager";
    changelog = "https://github.com/prometheus/alertmanager/blob/v${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ benley fpletz globin Frostman ];
  };
}
