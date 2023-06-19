{ inputs, outputs, lib, config, pkgs, nix-colors, ... }:

let inherit (nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
in {
  # You can import other home-manager modules here
  imports = [
    nix-colors.homeManagerModules.default
    outputs.homeManagerModules.hyprland
    outputs.homeManagerModules.alacritty
    outputs.homeManagerModules.tmux
    outputs.homeManagerModules.rofi
    outputs.homeManagerModules.scripts
    outputs.homeManagerModules.desktopEntries
    outputs.homeManagerModules.rustup
    outputs.homeManagerModules.git
    outputs.homeManagerModules.neovim
    outputs.homeManagerModules.fish
    outputs.homeManagerModules.mako
  ];

  colorScheme = nix-colors.colorSchemes.ayu-dark;

  nixpkgs = {
    overlays = [ outputs.overlays.additions ];
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
    discord
    neofetch
    hyprpaper
    cava
    slurp
    grim
    wl-clipboard
    wireplumber
    ncmpc
    yt-dlp
    ffmpeg-full
    armcord
    btop
    killall
    lua53Packages.fennel
    fnlfmt
    ripgrep
    yue
    rust-analyzer
    imagemagick
    qbittorrent
    telegram-desktop
    mpv
    wf-recorder
    imv
    prismlauncher
    pkg-config
    obs-studio
    pcmanfm
    bitwarden
    tic80
    gimp
    steam
    gzdoom
    gamescope
    qpwgraph
    cool-retro-term
    ark
    protontricks
    fzf
    sshfs
    craftos-pc
    virt-manager
    sccache
    blender
    pulseaudio # for pactl
    gnome.gnome-calculator
    wine
    winetricks
    p7zip
  ];

  gtk = {
    enable = true;
    cursorTheme = {
      name = "Catppuccin-Latte-Mauve-Cursors";
      package = pkgs.catppuccin-cursors.frappeMauve;
    };
  };
  gtk.theme = {
    name = "${config.colorScheme.slug}";
    package = gtkThemeFromScheme { scheme = config.colorScheme; };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}
