{ config, pkgs, ... }:

let
  unstable = import <unstable> {
    config = {
      # Allow specific insecure packages
      permittedInsecurePackages = [ 
        "dotnet-sdk-6.0.428" 
        "dotnet-runtime-6.0.36"
      ];
      #allowInsecure = true; # Alternative option if `permittedInsecurePackages` doesn’t work
    };
  };
  lib = pkgs.lib; # Import the `lib` library
in
{
  # User information
  home.username = "kyle";
  home.homeDirectory = "/home/kyle";

  # Home Manager release compatibility
  home.stateVersion = "24.11";

  # Global nixpkgs configuration
  nixpkgs.config = {
    # Allow specific unfree packages
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "spotify"
      "bambu-studio"
      "vscode-fhs"
      "vscode"
      "code"
    ];

    # Allow specific insecure packages
    permittedInsecurePackages = [
      "dotnet-sdk-6.0.428"
    ];
  };


  # Install packages
  home.packages = with pkgs; [
    tmux
    neovim
    git
    unstable.eddie # Add Eddie from unstable channel
    bambu-studio
    spotify
    vscode-fhs
  ];

  # Configure Git
  programs.git = {
    enable = true;

    extraConfig = {
      user.name = "robarmstrong96";
      user.email = "kylearmstrong96@outlook.com";
      core.editor = "nvim";
      pull.rebase = "true";
      init.defaultBranch = "main";
    };

    aliases = {
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
      lg = "log --oneline --graph --decorate --all";
    };
  };

  # Home Manager manages itself
  programs.home-manager.enable = true;

  # Environment variables
  home.sessionVariables = {
    # Uncomment and modify as needed
    # EDITOR = "nvim";
  };

  # Manage dotfiles
  home.file = {
    # Uncomment and modify as needed
    # ".screenrc".source = ./dotfiles/screenrc;
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
}
