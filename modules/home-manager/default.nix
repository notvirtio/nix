{
  hyprland = import ./hyprland.nix;
  kitty = import ./kitty.nix;
  tmux = import ./tmux.nix;
  rofi = import ./rofi.nix;
  scripts = import ./scripts.nix;
  crt = import ./crt.nix;
  desktopEntries = import ./desktopEntries.nix;
}
