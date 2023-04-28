{
  hyprland = import ./hyprland.nix;
  foot = import ./foot.nix;
  tmux = import ./tmux.nix;
  rofi = import ./rofi.nix;
  scripts = import ./scripts.nix;
  crt = import ./crt.nix;
  desktopEntries = import ./desktopEntries.nix;
  gpg = import ./gpg.nix;
  rustup = import ./rustup.nix;
  git = import ./git.nix;
  neovim = import ./nvim.nix;
}
