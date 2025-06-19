# As of 2025-06-08, version 3.11.1 will build and run seemingly with no issues.
# However, as can be seen in the packaging PR for version 3.11.1, it
# actually requires a new dependency and a patch of an existing one.
# So... I wait for that PR to get merged.
{
  lib,
  fetchFromGitHub,
  cmake,
  boost,
  ceres-solver,
  eigen,
  freeimage,
  glog,
  libGLU,
  glew,
  flann,
  cgal,
  gmp,
  mpfr,
  autoAddDriverRunpath,
  qt5,
  xorg,
  cudaPackages,
}:
cudaPackages.backendStdenv.mkDerivation rec {
  version = "3.9.1";
  pname = "colmap";
  src = fetchFromGitHub {
    owner = "colmap";
    repo = "colmap";
    rev = version;
    hash = "sha256-Xb4JOttCMERwPYs5DyGKHw+f9Wik1/rdJQKbgVuygH8=";
  };

  cmakeFlags = [
    (lib.cmakeBool "CUDA_ENABLED" true)
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" "61")
  ];

  buildInputs = [
    (boost.override {enableStatic = true;})
    ceres-solver
    eigen
    (freeimage.overrideAttrs (old: {
      meta = old.meta // {knownVulnerabilities = [];};
    }))
    glog
    libGLU
    glew
    qt5.qtbase
    flann
    cgal
    gmp
    mpfr
    xorg.libSM
    cudaPackages.cudatoolkit
    cudaPackages.cuda_cudart.static
  ];

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
    autoAddDriverRunpath
  ];
}
