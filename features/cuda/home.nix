{pkgs, ...}: {
  home.packages = with pkgs.cudaPackages; [
    cudatoolkit
    cuda_cudart
    cuda_nvcc
    # cudnn
  ];
}
