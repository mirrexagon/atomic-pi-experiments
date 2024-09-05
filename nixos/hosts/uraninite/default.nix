{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./disk-configuration.nix
  ];

  system.stateVersion = "24.05";
}

