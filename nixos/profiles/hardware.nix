{ config, lib, pkgs, ... }:

{
  # Links to check:
  # - https://www.kernel.org/doc/html/v5.5/i2c/old-module-parameters.html

  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
    dmidecode
    i2c-tools
  ];

  boot.kernelParams = [ ];

  boot.kernelPatches = [
    /*{
      name = "crashdump-config";
      patch = null;
      extraConfig = ''
      CRASH_DUMP y
      DEBUG_INFO y
      PROC_VMCORE y
      LOCKUP_DETECTOR y
      HARDLOCKUP_DETECTOR y
      '';
    }*/
  ];
}
