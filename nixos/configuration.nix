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
      ./hardware-configuration.nix
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

      nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;

      settings = {
        # Enable flakes and new 'nix' command
        experimental-features = "nix-command flakes";
        # Deduplicate and optimize nix store
        auto-optimise-store = true;
      };
    };

  # FIXME: Add the rest of your current configuration
  programs.hyprland.enable = true;
  #programs.hyprland.package = pkgs.hyprland-nvidia;
  programs.hyprland.nvidiaPatches = true;

  # TODO: Set your hostname
  networking.hostName = "NixBTW";
  networking.extraHosts = ''
    192.168.100.100 pi
  '';

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  programs.fish.enable = true;
  users.users.virtio = {
    isNormalUser = true;
    extraGroups = [ "wheel" "uucp" "docker" ];
    shell = pkgs.fish;
  };

  virtualisation.docker.enable = true;

  sound.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
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
    };
  };

  services.mpd.user = "virtio";
    systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };

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

  fonts.fonts = with pkgs; [
   comic-mono
   spleen
   (nerdfonts.override { fonts = [ "Iosevka" ]; })
  ];

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}
