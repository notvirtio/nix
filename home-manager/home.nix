{ inputs, outputs, lib, config, pkgs, nix-colors, ... }: {
  # You can import other home-manager modules here
  imports = [
    nix-colors.homeManagerModules.default
    outputs.homeManagerModules.hyprland
    outputs.homeManagerModules.alacritty
    outputs.homeManagerModules.tmux
    outputs.homeManagerModules.rofi
    outputs.homeManagerModules.scripts
    outputs.homeManagerModules.crt
    outputs.homeManagerModules.desktopEntries
    outputs.homeManagerModules.rustup
    outputs.homeManagerModules.git
    outputs.homeManagerModules.neovim
    #outputs.homeManagerModules.qutebrowser
  ];

  colorScheme = nix-colors.colorSchemes.dracula;

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
    ];
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  home = {
    username = "virtio";
    homeDirectory = "/home/virtio";
  };

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  programs.firefox.enable = true;

  home.packages = with pkgs; [
    discord neofetch hyprpaper cava
    slurp grim wl-clipboard wireplumber
    ncmpc yt-dlp ffmpeg armcord
    btop killall craftos-pc
    lua53Packages.fennel fnlfmt
    ripgrep yue rust-analyzer
    imagemagick qbittorrent telegram-desktop
    mpv cliscord wf-recorder
    imv prismlauncher pkg-config
    obs-studio cinnamon.nemo bitwarden
    openvpn tic80 gimp
  ];

  gtk = {
      enable = true;
      cursorTheme = {
        name = "Dracula-cursors";
        package = pkgs.dracula-theme;
      };
      theme = {
        package = pkgs.dracula-theme;
        name = "Dracula";
      };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
