# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];
  virtualisation = {
    containers = {
      enable = true;
    };
    spiceUSBRedirection = {
      enable = true;
    };
    libvirtd = {
      enable = true;
      qemu = {
        swtpm = {
          enable = true;
        };
        ovmf = {
          enable = true;
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
  # Bootloader.
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
    plymouth = {
      enable = true;
      theme = "catppuccin-mocha";
      themePackages = with pkgs; [
        (catppuccin-plymouth.override {
          variant = "mocha";
        })
      ];
    };
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166"
      "vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173"
      "vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 10;
    loader = {
      efi = {
        canTouchEfiVariables = true;
      };
      systemd-boot = {
        enable = true;
      };
    };
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };
  networking.hostName = "Karimihub"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = [pkgs.networkmanager-l2tp pkgs.networkmanager-openvpn];

  # Set your time zone.
  time.timeZone = "Asia/Tehran";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  security = {
    rtkit = {
      enable = true;
    };
    polkit = {
      enable = true;
    };
  };

  powerManagement.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    defaultUserShell = pkgs.zsh;
    users = {
        karimi = {
        isNormalUser = true;
        description = "Muhammed Hussein Karimi";
        extraGroups = [ "networkmanager" "wheel" "libvirtd" "disk" "audio" ];
        useDefaultShell = true;
        # packages = with pkgs; [];
      };
    };
  };
  programs = {
    zsh = {
      enable = true;
    };
    nix-ld = {
      enable = true;
    };
    winbox = {
      enable = true;
      openFirewall = true;
    };
    virt-manager = {
      enable = true;
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "karimi" = {
        imports = [
          ./home.nix
        ];
      };
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "karimi" ];
      sandbox = true;
      auto-optimise-store = true;
      cores = 5;
      substituters = [
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
        "https://cache.nixos.org"
        "https://nixpkgs-wayland.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      ];

    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  # ];
  environment.pathsToLink = [ "/share/zsh" ];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  services = {
    spice-vdagentd = {
      enable = true;
    };
    smartd = {
      enable = true;
      devices = [
        {
          device = "/dev/nvme0n1";
        }
      ];
    };
    blueman = {
      enable = true;
    };
    thermald.enable = true;
    upower.enable = true;
    xserver = {
      videoDrivers =
      [
        "modesetting"
        "fbdev"
        "nvidia"
      ];
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    displayManager = {
      ly = {
        enable = true;
      };
    };
  };
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ 80 443 8080 8000 8443 6443 3000 5000 ];
      allowedUDPPorts = [];
    };
  };

  programs = {
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
  };

  systemd.services = {
      battery-charge-threshold = {
        description = "Set the battery charge threshold";
        after = ["multi-user.target"];
        startLimitBurst = 0;
        serviceConfig = {
          Type = "oneshot";
          Restart = "on-failure";
          ExecStart = "/run/current-system/sw/bin/bash -c 'echo 80 > /sys/class/power_supply/BAT0/charge_control_end_threshold'";
        };
        wantedBy = ["graphical-session.target" "default.target"];
      };
  };

  system.stateVersion = "25.11";
  hardware.graphics = {
    enable = true;
  };
  services.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
  };
  hardware.enableAllFirmware = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
    };
    };
  };
  services.pipewire = {
    enable = false;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
  services.pipewire.wireplumber.extraConfig.bluetoothEnhancements = {
    "monitor.bluez.properties" = {
        "bluez5.enable-sbc-xq" = true;
        "bluez5.enable-msbc" = true;
        "bluez5.enable-hw-volume" = true;
        "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
    };
  };

  # Load nvidia driver for Xorg and Wayland

  hardware.nvidia = {

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = false;
      };
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = true;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
}
