{ config, lib, pkgs, nix-colors, ... }:

let inherit (nix-colors.lib-contrib { inherit pkgs; }) shellThemeFromScheme;
in {
  home.packages = with pkgs; [ thefuck ];
  programs.zsh.enable = true;
  programs.starship.enable = true;

  home.file.".config/direnv/lib/use_flake.sh".text = ''
    use_flake() {
      watch_file flake.nix
      watch_file flake.lock
      eval "$(nix print-dev-env --profile "$(direnv_layout_dir)/flake-profile")"
    }
  '';

  # extra stuff
  programs.bat.enable = true;
  programs.exa.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    shellAliases = {
      lg = "lazygit";
      v = "nvim";
      cat = "bat";
      ls = "exa -lh";
      useflake = "echo \"use flake\" > .envrc && direnv allow";
    };

    # just for the ctrl + left and right
    oh-my-zsh = {
      enable = true;
      plugins = [ "thefuck" ];
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
