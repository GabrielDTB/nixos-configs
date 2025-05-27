{ lib, stdenvNoCC, makeWrapper, rakudo, ripgrep, fzf, bat }:
stdenvNoCC.mkDerivation {
  pname = "fze";
  version = "0.0.0";

  src = ./.;

  nativeBuildInputs = [ makeWrapper rakudo ];
  buildInputs = [ ripgrep fzf bat ];

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 fze.raku $out/bin/fze
    patchShebangs $out/bin/fze
    wrapProgram $out/bin/fze \
      --prefix PATH : ${lib.makeBinPath [ ripgrep fzf bat ]}
  '';
}
