{ config, lib, pkgs, nix-colors, ... }:

let inherit (nix-colors.lib-contrib { inherit pkgs; }) shellThemeFromScheme;
in {
  home.packages = with pkgs; [ thefuck ];
  programs.zsh.enable = true;
  #programs.starship.enable = true;

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

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" "rust" ];
      theme = "avit";
    };

    initExtra = ''
      export PATH="$HOME/.cargo/bin:$PATH"
      export RUSTC_WRAPPER="$(whereis sccache | awk '{ print $2 }')"
      export NIXPKGS_ALLOW_UNFREE=1
      export CARGO_INCREMENTAL=0
    '';

  };
}
