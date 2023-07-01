# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)

{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other NixOS modules here
  imports = [
    # outputs.nixosModules.example
    outputs.nixosModules.gpg

    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./desktop-hardware.nix
  ];

  nixpkgs = {
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  services.xserver.windowManager.bspwm.enable = true;
  programs.hyprland.enable = true;
  programs.hyprland.nvidiaPatches = true;

  services.xserver.enable = true;
  services.xserver.displayManager.sddm = {
    enable = true;
    #settings.Autologin = {
    #  User = "virtio";
    #  Session = "hyprland.desktop";
    #};
  };

  # TODO: Set your hostname
  networking.hostName = "NixBTW";
  networking.extraHosts = ''
    192.168.100.100 pi
    46.29.236.25 vps
  '';

  time.timeZone = "Europe/Moscow";

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  programs.zsh.enable = true;
  users.users.virtio = {
    isNormalUser = true;
    extraGroups = [ "wheel" "uucp" "docker" "libvirtd" ];
    shell = pkgs.zsh;
  };
  programs.dconf.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;

  sound.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  networking.firewall = { allowedUDPPorts = [ 51820 ]; };
  networking.wg-quick.interfaces = {
    wg0 = {
      address = [ "10.66.66.10/32" "fd42:42:42::10/128" ];
      dns = [ "1.1.1.1" "1.0.0.1" ];
      privateKeyFile = "/home/virtio/.wgprivkey";

      peers = [{
        publicKey = "7ReuCcTa98WVlkWBYv7SwSBudgpmkrpZzF9MQkkOM3A=";
        presharedKeyFile = "/home/virtio/.wgpresharedkey";
        allowedIPs = [ "0.0.0.0/0" "::/0" ];
        endpoint = "46.29.236.25:58248";
        persistentKeepalive = 25;
      }];
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
    nvidia = {
      open = false;
      modesetting.enable = true;
    };
    opengl = {
      enable = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
      ];
    };
    opentabletdriver = { enable = true; };
  };

  services.mpd.user = "virtio";
  systemd.services.mpd.environment = { XDG_RUNTIME_DIR = "/run/user/1000"; };

  services.gvfs.enable = true;

  services.mpd = {
    enable = true;
    musicDirectory = "/home/virtio/music";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "My PipeWire Output"
      }
    '';
  };

  fonts.fonts = with pkgs; [ (nerdfonts.override { fonts = [ "Mononoki" ]; }) ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
