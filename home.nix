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

  home.sessionPath = [
    "/home/karimi/.krew/bin"
  ];

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
    (nerdfonts.override { fonts = [ "ComicShannsMono" ]; })
    firefox
    kubectl
    wlogout
    jq
    kubecolor
    vazir-fonts
    lsd
    btop
    bat
    dogdns
    prettyping
    viddy
    nerdfetch
    krew
    delve
    gopls
    pyright
    fzf
    ansible
    ansible-lint
    go
    materialgram
    p7zip
    clipse
    ripgrep
    gnumake
    golines
    gotools
    reftools
    golangci-lint
    govulncheck
    mockgen
    impl
    ginkgo
    gofumpt
    gomodifytags
    iferr
    luajit
    tree-sitter
    nodejs_22
    wl-clipboard
    lua-language-server
    nginx-language-server
    python312Packages.python-lsp-server
    nil
    cargo
    rustc
    openssl
    curlie
  ];
  programs = {
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
    pyenv = {
      enable = true;
      enableZshIntegration = true;
    };
    rbenv = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;

      initExtraFirst = ''
      source "$HOME/.local/share/zsh/custom/themes/typewritten/typewritten.zsh-theme"
      display_kube_context() {
        tw_kube_context="\u2388 | $(kubectl config view --minify --output json | jq -r '(."contexts"[0]."context"."user" + "@" + ."contexts"[0]."context"."cluster" + ":" + ."contexts"[0]."context"."namespace")' 2> /dev/null)"
        if [[ $tw_kube_context != "" ]]; then
          echo -n "($tw_kube_context)"
        fi
      }
      autoload -U compinit && compinit
      '';
      initExtra = ''
      source <(kubectl completion zsh)
      compdef k='kubectl'
      '';
      shellAliases = {
        ll = "ls -l";
        update = "sudo nixos-rebuild switch --flake '/etc/nixos?submodules=1#default'";
        make = "make -j$(nproc)";
        ninja = "ninja -j$(nproc)";
        c = "clear";
        n = "ninja";
        dir = "ls";
        ls = "lsd -h --group-dirs first";
        tree = "lsd --tree";
        top = "btop";
        htop = "btop";
        bat = "bat --theme='Catppuccin Mocha'";
        "-g -- --help" = "--help 2>&1 | bat --plain --language=help";
        cat = "bat --pager=never";
        less = "bat";
        oldless = "bat --plain";
        oldcat = "bat --plain --pager=never";
        dig = "dog";
        ping = "prettyping";
        kubectl = "kubecolor";
        k = "kubectl";
        watch = "viddy";
        tarnow = "tar -acf ";
        wget = "wget -c ";
        untar = "tar -zxvf ";
        vim = "nvim";
        vi = "nvim";
        tb = "nc termbin.com 9999";
        ssh = "kitten ssh";
        oldssh = "/run/current-system/sw/bin/ssh";
        icat = "kitten icat";
        diff = "kitten diff";
        curl = "curlie";
      };
      sessionVariables = {
        MANPAGER = "sh -c 'col -bx | bat -l man'";
        EDITOR = "nvim";
        TYPEWRITTEN_SYMBOL = "λ ";
        TYPEWRITTEN_PROMPT_LAYOUT = "half_pure";
        TYPEWRITTEN_RELATIVE_PATH = "home";
        TYPEWRITTEN_LEFT_PROMPT_PREFIX_FUNCTION = "display_kube_context";
        HISTCONTROL = "ignoreboth";
      };
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "extract" "timer" "fzf" ];
      };
      history = {
        size = 10000;
        path = "${config.xdg.dataHome}/zsh/history";
        ignorePatterns = [
          "&:[bf]g:c:clear:history:exit:q:pwd:* --help"
        ];
      };
    };
  };
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Vazirmatn" ];
        sansSerif = [ "Vazirmatn" ];
        monospace = [ "ComicShannsMono Nerd Font Mono" ];
      };
    };
  };

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
    ".config/dunst" = {
      source = ./dunst;
      recursive = true;
    };
    ".config/lsd" = {
      source = ./lsd;
      recursive = true;
    };
    ".config/bat" = {
      source = ./bat;
      recursive = true;
    };
    ".local/share/zsh/custom/themes/typewritten" = {
      source = ./typewritten;
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
        safe.directory = "/etc/*";
        color = {
          ui = "auto";
        };
        color.branch = {
          current = "cyan bold reverse";
          local = "white";
          plain = "";
          remote = "cyan";
        };
        color.diff = {
          commit = "";
          func = "cyan";
          plain = "";
          whitespace = "magenta reverse";
          meta = "white";
          frag = "cyan bold reverse";
          old = "red";
          new = "green";
        };
        color.grep = {
          context = "";
          filename = "";
          function = "";
          linenumber = "white";
          match = "";
          selected = "";
          separator = "";
        };
        color.interactive = {
          error = "";
          header = "";
          help = "";
          prompt = "";
        };
        color.status = {
          added = "green";
          changed = "yellow";
          header = "";
          localBranch = "";
          nobranch = "";
          remoteBranch = "cyan bold";
          unmerged = "magenta bold reverse";
          untracked = "red";
          updated = "green bold";
        };
      };
    };
    kitty = {
      enable = true;
    };
    home-manager = {
     enable = true;
    };
  };
}
