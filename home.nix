{ config, pkgs, ... }:

let
  unstable = import <unstable> {};
in
{
  # User information
  home.username = "kyle";
  home.homeDirectory = "/home/kyle";

  # Home Manager release compatibility
  home.stateVersion = "24.11";

  # Install packages
  home.packages = with pkgs; [
    tmux
    neovim
    git
    unstable.eddie # Add Eddie from unstable channel
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
