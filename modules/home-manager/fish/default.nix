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
      starship init fish | source
    '';

  };
}
