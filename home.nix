{ config, pkgs, ... }:

let
  unstable = import <unstable> {
    config = {
      # Allow specific insecure packages
      permittedInsecurePackages = [ 
        "dotnet-sdk-6.0.428" 
        "dotnet-runtime-6.0.36"
      ];
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
    nixfmt
  ];

  systemd.user.services.eddie-elevated = {
    Unit = {
      Description = "Eddie Elevated Service";
      After = "default.target";  # Define dependencies in Unit
      Requires = "default.target";
    };
    Install = {
      WantedBy = [ "default.target" ];  # Specify what enables this service
    };
    Service = {
      Type = "simple";
      ExecStart = "/usr/lib/eddie-ui/eddie-cli-elevated elevation=sudo service";
      Restart = "always";
      RestartSec = "5s";
      TimeoutStopSec = "5s";

      # Allow access to system-level operations
      CapabilityBoundingSet = [
        "CAP_NET_ADMIN"
        "CAP_NET_RAW"
      ];
      AmbientCapabilities = [
        "CAP_NET_ADMIN"
        "CAP_NET_RAW"
      ];
    };
  };

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

  # Configure Zsh
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" "history-substring-search" ];
      theme = "cloud"; # Change this to your preferred theme
    };

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };

    history.size = 10000;
  };

  # Home Manager manages itself
  programs.home-manager.enable = true;

  # Environment variables
  home.sessionVariables = {
    EDITOR = "nvim";
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
