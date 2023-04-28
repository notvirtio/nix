
{ inputs, outputs, lib, config, pkgs, ... }: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/home-manager):
    outputs.homeManagerModules.hyprland
    outputs.homeManagerModules.kitty
    outputs.homeManagerModules.tmux
    outputs.homeManagerModules.rofi
    outputs.homeManagerModules.scripts
    outputs.homeManagerModules.crt
    outputs.homeManagerModules.desktopEntries

    # Or modules exported from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModules.default

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      #outputs.overlays.additions
      #outputs.overlays.modifications
      #outputs.overlays.unstable-packages

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
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "virtio";
    homeDirectory = "/home/virtio";
  };

  # Add stuff for your user as you see fit:
  programs.neovim.enable = true;

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  programs.firefox.enable = true;

  home.packages = with pkgs; [
    discord neofetch
    hyprpaper cava
    slurp grim
    wl-clipboard wireplumber
    ncmpc yt-dlp
    ffmpeg armcord
    btop
  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
