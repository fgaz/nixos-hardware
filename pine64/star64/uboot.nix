{ fetchFromGitLab
, buildUBoot
, opensbi
}:

buildUBoot {
  version = "2025.01-unstable-2025-03-25";

  src = fetchFromGitLab {
    domain = "source.denx.de";
    owner = "u-boot";
    repo = "u-boot";
    rev = "3962acf0a492fb3dbf1d3780a7c7367a7b25b065";
    hash = "sha256-TigOmE9engN7Hs6v+ucwUM1Ju9j/8E3gPvll4cXSFg8=";
  };

  extraMakeFlags = [
    "OPENSBI=${opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.bin"
  ];

  defconfig = "starfive_visionfive2_defconfig";

  filesToInstall = [
    "spl/u-boot-spl.bin.normal.out"
    "u-boot.itb"
  ];
}
