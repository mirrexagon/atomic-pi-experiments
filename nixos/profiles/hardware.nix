{ config, lib, pkgs, ... }:

{
  # SoC I2C bus I2C2 has a BNO055 on it.
  # Loading the `i2c-dev` kernel module, something is found by i2cdetect (using
  # SMBus receive byte command since quick command is not available on the SoC
  # I2C buses) on /dev/i2c-2 at address 0x28.
  # That is the bus and address we expect the BNO055 on.

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
