{
  description = "AnycubicSlicerNext - 3D printer slicer based on OrcaSlicer";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      anycubic-slicer-next = pkgs.callPackage ./default.nix {
        cgal = pkgs.cgal_5;
        src = pkgs.fetchFromGitHub {
          owner = "ANYCUBIC-3D";
          repo = "AnycubicSlicerNext";
          # Track the AnycubicSlicerNext develop branch (pinned for reproducibility).
          rev = "987a3c2bf9ed13934137326bfd522896c70e5101";
          hash = "sha256-CWGP+qnwrquVW75uCmXfBMh3QPhfa2sSpZbxuG/5P94=";
        };
        openPluginsSrc = pkgs.fetchFromGitHub {
          owner = "ANYCUBIC-3D";
          repo = "open-plugins";
          # Pin the SDK's develop branch for reproducible builds.
          rev = "e3bdacc1a11bf925760abcc8b022005780363db6";
          hash = "sha256-jxtzrDEDY8o9lXGHef3IY0r52VDhMPXX7Wlw13JeWM0=";
        };
        wxwidgetsSrc = pkgs.fetchgit {
          url = "https://github.com/wxWidgets/wxWidgets.git";
          rev = "refs/tags/v3.3.4";
          hash = "sha256-J04XE/62Ih+ZnYkl3cMEAAKRnFhPmOynMbZUbozk/gY=";
          fetchSubmodules = true;
        };
        libnoiseSrc = pkgs.fetchzip {
          url = "https://github.com/SoftFever/Orca-deps-libnoise/archive/refs/tags/1.0.zip";
          hash = "sha256-nzvtWsYz4REVcPRpKysOPOYIlMNhfbDHTkyS7PKvY+c=";
        };
      };
    in {
      packages.${system} = {
        default = anycubic-slicer-next;
        anycubic-slicer-next = anycubic-slicer-next;
      };
    };
}
