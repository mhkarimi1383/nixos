{ inputs, config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "karimi";
  home.homeDirectory = "/home/karimi";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    vim
    python312Full
    neovim
    tmux
    inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
    gcc
    waybar
    brightnessctl
    playerctl
    networkmanagerapplet
    hyprpaper
    hypridle
    fuzzel
    dunst
    nerdfonts
    firefox
    kubectl
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/hypr" = {
      source = ./hypr;
      recursive = true;
    };
    ".config/kitty" = {
      source = ./kitty;
      recursive = true;
    };
    ".config/nvim" = {
      source = ./nvim;
      recursive = true;
    };
    ".config/waybar" = {
      source = ./waybar;
      recursive = true;
    };
    ".config/fuzzel" = {
      source = ./fuzzel;
      recursive = true;
    };
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/karimi/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
  };
  wayland = {
    windowManager = {
        hyprland = {
        enable = true;
        extraConfig = (builtins.readFile hypr/hyprland.conf);
        xwayland = {
          enable = true;
        };
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      };
    };
  };
  services = {
    hyprpaper = {
      enable = true;
      settings = {
preload = "~/.config/hypr/assets/dark-cat-rosewater.png";
wallpaper = ",~/.config/hypr/assets/dark-cat-rosewater.png";
};
    };
    hypridle = {
      enable = true;
      settings = {
general = {
    lock_cmd = "pidof hyprlock || hyprlock";       # avoid starting multiple hyprlock instances.
    before_sleep_cmd = "loginctl lock-session";    # lock before suspend.
    after_sleep_cmd = "hyprctl dispatch dpms on";  # to avoid having to press a key twice to turn on the display.
};

listener = [
{
    timeout = 150;                                # 2.5min.
    on-timeout = "brightnessctl -s set 10";         # set monitor backlight to minimum, avoid 0 on OLED monitor.
    on-resume = "brightnessctl -r";                 # monitor backlight restore.
}

# turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
{
    timeout = 150;                                          # 2.5min.
    on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
    on-resume = "brightnessctl -rd rgb:kbd_backlight";        # turn on keyboard backlight.
}

{
    timeout = 300;                                 # 5min
    on-timeout = "loginctl lock-session";            # lock screen when timeout has passed
}

{
    timeout = 330;                                 # 5.5min
    on-timeout = "hyprctl dispatch dpms off";        # screen off when timeout has passed
    on-resume = "hyprctl dispatch dpms on";          # screen on when activity is detected after timeout has fired.
}

{
    timeout = 1800;                                # 30min
    on-timeout = "systemctl suspend";                # suspend pc
}];
};
    };
  }; 
  programs = {
    hyprlock = {
      enable = true;
    };
    git = {
      enable = true;
      userName = "Muhammed Hussein Karimi";
      userEmail = "info@karimi.dev";
      extraConfig = {
        safe.directory = "/etc/nixos";
      };
    };
    kitty = {
      enable = true;
    };
    home-manager = {
     enable = true;
    };
  };
#   hardware = {
#     opengl = {
#       enable = true;
#     };
#     nvidia = {
#       modesetting = {
#         enable = true;
#       };
#     };
#   };
}
