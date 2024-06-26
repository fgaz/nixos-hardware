{ lib, callPackage, linuxPackagesFor, kernelPatches, ... }:

let
  modDirVersion = "6.6.20";
  linuxPkg = { lib, fetchFromGitHub, buildLinux, ... }@args:
    buildLinux (args // {
      version = "${modDirVersion}-fishwaldo-star64";

      src = fetchFromGitHub {
        owner = "Fishwaldo";
        repo = "Star64_linux";
        rev = "3db9e00b0c0ee62799ca4864dadee491b6aa6bb3"; # Pine64_6.6 branch
        hash = "sha256-ElBnJz7japt9m4EKMzOwPK/zF9CRyxfsoMsC8NnyWWI=";
      };

      inherit modDirVersion;
      defconfig = "pine64_star64_defconfig";
      kernelPatches = [
         { patch = ./irq-desc-to-data.patch; }
         { patch = ./wm8960-license.patch; }
      ] ++ kernelPatches;

      structuredExtraConfig = with lib.kernel; {
        # Disable stuff that doesn't build
        # https://github.com/starfive-tech/linux/issues/79

        # 'struct i2c_driver' has no member named 'probe_new'
        # and -Werror=incompatible-pointer-types
        VIN_SENSOR_OV5640 = no;
        VIN_SENSOR_SC2235 = no;

        # modpost: module starfivecamss uses symbol dma_buf_get from namespace DMA_BUF, but does not import it.
        VIDEO_STF_VIN = no;

        # modpost: module panel-starfive-jadard uses symbol st_accel_get_settings from namespace IIO_ST_SENSORS, but does not import it.
        DRM_PANEL_STARFIVE_JADARD = no;

        # Misplaced includes
        DRM_IMG_ROGUE = no;
        DRM_VERISILICON = no;

        # https://github.com/starfive-tech/linux/pull/86
        DRM_I2C_NXP_TDA998X = no;
      };

      extraMeta.branch = "Pine64_6.6";
    } // (args.argsOverride or { }));

in lib.recurseIntoAttrs (linuxPackagesFor (callPackage linuxPkg { }))
