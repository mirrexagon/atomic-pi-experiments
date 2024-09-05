{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.wireless.enable = true;

  time.timeZone = lib.mkDefault "Australia/Melbourne";

  environment.systemPackages = with pkgs; [
    kakoune
    tmux
    ripgrep
    fd
  ];

  users.users = {
    mir = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];

      openssh.authorizedKeys.keys = [
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPF/M7nh7U3pjiwp0EHFHPcA0VlztKHMwX/8JrNrpeoqAAAABHNzaDo= mir-2023-03-23-23497091"
        "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMVrQg2kPfZHL+laut8n+6LpfBW5KDKwzX8HkdcqZf/wAAAABHNzaDo= mir-2023-03-23-23497095"
      ];
    };

    root.openssh.authorizedKeys.keys = [
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIPF/M7nh7U3pjiwp0EHFHPcA0VlztKHMwX/8JrNrpeoqAAAABHNzaDo= mir-2023-03-23-23497091"
      "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIMVrQg2kPfZHL+laut8n+6LpfBW5KDKwzX8HkdcqZf/wAAAABHNzaDo= mir-2023-03-23-23497095"
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
    };
  };

  security.sudo.wheelNeedsPassword = false;

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
    settings.trusted-users = [ "@wheel" ];
  };
}
