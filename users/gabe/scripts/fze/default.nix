{ lib, stdenv, makeWrapper, haskellPackages, ripgrep, fzf, bat }:

let
  ghc = haskellPackages.ghcWithPackages (p: [ p.relude p.shh ]);
in

stdenv.mkDerivation {
  pname = "fze";
  version = "0.0.0";
  src = ./.;

  nativeBuildInputs = [
    makeWrapper
    ghc
  ];
  buildInputs = [
    ripgrep
    fzf
    bat
  ];

  buildPhase = ''
    ${ghc}/bin/ghc --make fze.hs -o fze -threaded -O2
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 fze $out/bin/fze
    wrapProgram $out/bin/fze \
      --prefix PATH : ${lib.makeBinPath [
        ripgrep
        fzf
        bat
      ]}
  '';
}
