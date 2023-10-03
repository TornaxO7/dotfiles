let
  pkgs = import <nixpkgs> {};
in
pkgs.mkShell {
  packages = with pkgs; [
    manim

    python310
    python310Packages.numpy
    python310Packages.matplotlib
    python310Packages.tensorflow
    python310Packages.keras
    python310Packages.h5py
    python310Packages.scikit-image
    python310Packages.pip
    python310Packages.torch
    python310Packages.torchvision
    python310Packages.cython
    python310Packages.tqdm
    python310Packages.scipy
    python310Packages.pyyaml
    python310Packages.tensorboardx
    python310Packages.tensorboardx
    python310Packages.seaborn
    python310Packages.pillow
    python310Packages.opencv4
    python310Packages.einops
    python310Packages.natsort
    python310Packages.timm
    python310Packages.openpyxl
    python310Packages.kornia
  ];
}
