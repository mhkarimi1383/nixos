{ inputs, config, pkgs, lib, ... }:

{
  nixpkgs.overlays = [inputs.nixpkgs-wayland.overlay];
  nixpkgs.config.allowUnfree = true;
  dconf = {
    settings = {
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
  };
  xdg = {
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = [
          "hyprland"
          "wlr"
          "gtk"
        ];
        hyprland.default = [
          "hyprland"
          "wlr"
          "gtk"
        ];
      };
      extraPortals = [
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
        inputs.nixpkgs-wayland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
  home = {
    sessionPath = [
      "/home/karimi/.krew/bin"
      "/home/karimi/.npm-packages/bin"
    ];
    username = "karimi";
    homeDirectory = "/home/karimi";
    stateVersion = "25.05";
    packages = with pkgs; [
      kind
      ansible
      ansible-lint
      kubectl
      kubecolor
      kubernetes-helm
      krew
      (minikube.override { withQemu = true; libvirt = pkgs.libvirt; } )
      # inputs.helmwave.helmwave

      polkit

      vim
      (neovim.override {withNodeJs = true;})
      tmux

      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
      inputs.nixpkgs-wayland.packages.${system}.waybar
      inputs.nixpkgs-wayland.packages.${system}.dunst
      inputs.nixpkgs-wayland.packages.${system}.wlogout
      inputs.nixpkgs-wayland.packages.${system}.wl-clipboard
      inputs.nixpkgs-wayland.packages.${system}.wlr-randr
      (hyprshot.override {hyprland = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland; })
      inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.hyprpaper
      inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}.hypridle
      inputs.hyprpolkitagent.packages.${pkgs.stdenv.hostPlatform.system}.hyprpolkitagent
      fuzzel
      networkmanagerapplet
      brightnessctl
      playerctl
      clipse
      catppuccin-cursors.mochaLavender
      brave
      firefox

      maple-mono.NF
      vazir-fonts

      (jetbrains.datagrip.override {
        vmopts = ''
        -Xms512m
        -Xmx8192m
        -XX:ReservedCodeCacheSize=512m
        -XX:+IgnoreUnrecognizedVMOptions
        -XX:+UseG1GC
        -XX:SoftRefLRUPolicyMSPerMB=50
        -XX:CICompilerCount=2
        -XX:+HeapDumpOnOutOfMemoryError
        -XX:-OmitStackTraceInFastThrow
        -ea
        -Dsun.io.useCanonCaches=false
        -Djdk.http.auth.tunneling.disabledSchemes=""
        -Djdk.attach.allowAttachSelf=true
        -Djdk.module.illegalAccess.silent=true
        -Dkotlinx.coroutines.debug=off
        -XX:ErrorFile=$USER_HOME/java_error_in_idea_%p.log
        -XX:HeapDumpPath=$USER_HOME/java_error_in_idea.hprof

        --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
        --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED

        -javaagent:/home/karimi/ja-netfilter/ja-netfilter.jar=jetbrains
        '';
      })
      (jetbrains.idea-ultimate.override {
        vmopts = ''
        -Xms512m
        -Xmx8192m
        -XX:ReservedCodeCacheSize=512m
        -XX:+IgnoreUnrecognizedVMOptions
        -XX:+UseG1GC
        -XX:SoftRefLRUPolicyMSPerMB=50
        -XX:CICompilerCount=2
        -XX:+HeapDumpOnOutOfMemoryError
        -XX:-OmitStackTraceInFastThrow
        -ea
        -Dsun.io.useCanonCaches=false
        -Djdk.http.auth.tunneling.disabledSchemes=""
        -Djdk.attach.allowAttachSelf=true
        -Djdk.module.illegalAccess.silent=true
        -Dkotlinx.coroutines.debug=off
        -XX:ErrorFile=$USER_HOME/java_error_in_idea_%p.log
        -XX:HeapDumpPath=$USER_HOME/java_error_in_idea.hprof

        --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED
        --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED

        -javaagent:/home/karimi/ja-netfilter/ja-netfilter.jar=jetbrains
        '';
      })
      python3Full
      go
      cobra-cli
      gnumake
      golines
      # gotools
      reftools
      golangci-lint
      govulncheck
      mockgen
      impl
      ginkgo
      gofumpt
      gomodifytags
      iferr
      delve
      gopls
      pyright
      gcc
      tree-sitter
      nodejs_22
      lua-language-server
      nginx-language-server
      python3Packages.python-lsp-server
      python3Packages.debugpy
      (luajit.withPackages(luajitPackages: [luajitPackages.magick luajitPackages.luarocks]))
      devenv
      nil
      nixfmt-rfc-style
      php
      php.packages.composer
      pnpm
      gitmux
      ruby
      temurin-bin
      java-language-server
      maven
      adoptopenjdk-icedtea-web
      ruff
      pre-commit

      podman-desktop
      podman-compose
      dive
      docker-machine-kvm2

      cloudflare-warp
      nekoray

      cava
      pamixer
      yazi
      gimp
      jq
      lsd
      btop
      curlie
      posting
      ripgrep
      bat
      dogdns
      prettyping
      viddy
      nerdfetch
      fastfetch
      fzf
      materialgram
      p7zip
      imagemagick
      cargo
      rustc
      openssl
      psmisc
      gitmoji-cli
      unzip
      nvtopPackages.full
      smartmontools
      remmina
      persepolis
      (qemu_full.override {cephSupport = false;})
      glxinfo
      usbutils
      swtpm
      procps
      pciutils
      trippy
      whois
      pavucontrol
      wget

      anydesk
      rustdesk
      openfortivpn
      winbox4
      fd

      thunderbird-latest
      birdtray
    ];
  };
  programs = {
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-pipewire-audio-capture
      ];
    };
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [
        "--cmd cd"
      ];
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      autocd = true;

      initContent = lib.mkBefore ''
      source "$HOME/.local/share/zsh/custom/themes/typewritten/typewritten.zsh-theme"
      display_kube_context() {
        tw_kube_context="\u2388 | $(kubectl config view --minify --output json | jq -r '(."contexts"[0]."context"."user" + "@" + ."contexts"[0]."context"."cluster" + ":" + ."contexts"[0]."context"."namespace")' 2> /dev/null)"
        if [[ $tw_kube_context != "" ]]; then
          echo -n "($tw_kube_context)"
        fi
      }
      compdef kubecolor=kubectl
      compdef k=kubectl
      '';
      shellAliases = {
        ll = "ls -l";
        upgrade = "sudo nix flake update --flake '/etc/nixos?submodules=1' && sudo nixos-rebuild switch --flake '/etc/nixos?submodules=1#default' --upgrade --upgrade-all -v";
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
        traceroute = "sudo trip";
      };
      sessionVariables = {
        MANPAGER = "bat -l man -p";
        EDITOR = "nvim";
        TYPEWRITTEN_SYMBOL = "λ ";
        TYPEWRITTEN_PROMPT_LAYOUT = "half_pure";
        TYPEWRITTEN_RELATIVE_PATH = "home";
        TYPEWRITTEN_LEFT_PROMPT_PREFIX_FUNCTION = "display_kube_context";
        HISTCONTROL = "ignoreboth";
        KIND_EXPERIMENTAL_PROVIDER = "podman";
        NODE_PATH = "/home/karimi/.npm-packages/lib/node_modules";
        JDTLS_JVM_ARGS = "-javaagent:$HOME/.local/share/java/lombok.jar";
        REGISTRY_AUTH_FILE = "/home/karimi/.podman-auth.json";
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
        monospace = [ "Maple Mono NF" ];
      };
    };
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".minikube/bin/docker-machine-driver-kvm2" = {
      source = "${pkgs.docker-machine-kvm2}/bin/docker-machine-driver-kvm2";
    };
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
    ".npmrc" = {
      source = ./npmrc;
    };
    ".local/share/zsh/custom/themes/typewritten" = {
      source = ./typewritten;
      recursive = true;
    };
    ".tmux.conf" = {
      source = ./tmux/tmux.conf;
    };
    ".config/tmux/plugins/catppuccin/tmux" = {
      source = ./tmux/catppuccin;
      recursive = true;
    };
    ".tmux/plugins/tpm" = {
      source = ./tmux/tpm;
      recursive = true;
    };
    ".gitmux.conf" = {
      source = ./tmux/gitmux.conf;
    };
    ".config/yazi/theme.toml" = {
      source = ./yazi/themes/mocha/catppuccin-mocha-lavender.toml;
    };
    ".config/cava/config" = {
      source = ./cava.ini;
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
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    NIXOS_OZONE_WL = "1";
    T_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
  systemd = {
    user = {
      timers = {
        battery-warning = {
          Install = {
            WantedBy = [ "timers.target" ];
          };
          Timer = {
            Unit = "battery-warning.service";
            OnBootSec = "1m";
            OnUnitActiveSec = "1m";
          };
        };
      };
      services = {
        battery-warning = {
          Service = {
            Type = "oneshot";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
            ExecStart = toString (
              pkgs.writeShellScript "battery-warning-script" ''
              set -eu
              STATUS=$(cat /sys/class/power_supply/BAT0/status)
              CURRENT_CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
              if [ "$STATUS" == "Discharging" ]; then
                if [ "$CURRENT_CAPACITY" -gt 22 ] && [ "$CURRENT_CAPACITY" -lt 26 ]; then
                  dunstify -a system -t 9000 -r 9990 -u normal "Battery Running Low" "$CURRENT_CAPACITY% Remaining"

                elif [ "$CURRENT_CAPACITY" -gt 12 ] && [ "$CURRENT_CAPACITY" -lt 16 ]; then
                  dunstify -a system -t 9000 -r 9990 -u critical "Low Battery: $CURRENT_CAPACITY%" "Connect charger\nWill Hibernate soon"


                elif [ "$CURRENT_CAPACITY" -lt 11 ]; then
                  dunstify -a system -t 0 -r 9990 -u critical "Battery Critically Low" "$CURRENT_CAPACITY% Remaining."
                fi
              fi
              ''
            );
          };
        };
      };
    };
  };


  wayland = {
    windowManager = {
        hyprland = {
          enable = true;
          extraConfig = (builtins.readFile hypr/hyprland.conf);
          portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
          systemd.enable = true;
          xwayland = {
            enable = true;
          };
          package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      };
    };
  };
  services = {
    blueman-applet = {
      enable = true;
    };
    hyprpaper = {
      enable = true;
      settings = {
        preload = "~/.config/hypr/assets/dark-cat-rosewater.png";
        wallpaper = ",~/.config/hypr/assets/dark-cat-rosewater.png";
        };
    };
    hypridle = {
      enable = true;
      package = inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}.hypridle;
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
        }];
      };
    };
  };
  programs = {
    hyprlock = {
      enable = true;
      package = inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock;
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
