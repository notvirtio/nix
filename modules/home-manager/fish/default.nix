{ config, lib, pkgs, nix-colors, ... }:

let inherit (nix-colors.lib-contrib { inherit pkgs; }) shellThemeFromScheme;
in {
  programs.fish.enable = true;
  programs.starship.enable = true;

  # extra stuff
  programs.bat.enable = true;
  programs.exa.enable = true;

  programs.fish = {
    shellAliases = {
      lg = "lazygit";
      v = "nvim";
      cat = "bat";
      ls = "exa -lh";
    };

    interactiveShellInit = ''
      sh ${shellThemeFromScheme { scheme = config.colorScheme; }}
      set PATH "$HOME/.cargo/bin:$PATH"
      export RUSTC_WRAPPER="$(whereis sccache | awk '{ print $2 }')"
      export CARGO_INCREMENTAL=0
      starship init fish | source
    '';

  };
}
