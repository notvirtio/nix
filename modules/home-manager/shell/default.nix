{ config, lib, pkgs, nix-colors, ... }:

let inherit (nix-colors.lib-contrib { inherit pkgs; }) shellThemeFromScheme;
in {
  home.packages = with pkgs; [ thefuck ];
  programs.zsh.enable = true;
  programs.starship.enable = true;

  # extra stuff
  programs.bat.enable = true;
  programs.exa.enable = true;

  programs.zsh = {
    shellAliases = {
      lg = "lazygit";
      v = "nvim";
      cat = "bat";
      ls = "exa -lh";
    };

    initExtra = ''
      export PATH="$HOME/.cargo/bin:$PATH"
      export RUSTC_WRAPPER=$(where sccache)
      export NIXPKGS_ALLOW_UNFREE=1
      export CARGO_INCREMENTAL=0
      eval $(starship init zsh)
    '';

  };
}
