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

 # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
 
  # Enable networking
  networking.networkmanager.enable = true;
  
  networking.firewall.allowedTCPPorts = [ 80 443 8000 8001 22 ];
  
  networking.enableIPv6 = true;
  
  services.tailscale.enable = true;
 # environment.sessionVariables = {
 #   NIX_SSL_CERT_FILE = "/etc/ssl/certs/certificate.crt";
 #   SSL_CERT_FILE = "/etc/ssl/certs/certificate.crt";
 # };  

  services = {
    postgresql.enable = true;
    redis.enable = true;
  };

 # services.nginx = {
 #   enable = true;

    # Server for redirecting HTTP -> HTTPS
 #   virtualHosts."http-redirect" = {
 #      serverName = "apisbot.ru";
       #addSSL = false;
       # Automatic redirection to HTTPS
       #forceSSL = true;
 #      locations."/".return = "301 https://$host$request_url";
 #   };

    # Main HTTPS server
#    virtualHosts."apisbot.ru" = {
#       enableACME = false; # Disable Let's Encrypt
#       addSSL = true; # Turn on SSL
       
       # Paths to SSL files
#       sslCertificate = "/etc/ssl/certs/certificate.crt";
#       sslCertificateKey = "/etc/ssl/private/private.key";

#       root = "/var/www";
#       extraConfig = ''
#         index index.php index.html;
#       '';
        

       # PHP 
 #      locations."~ \.php$" = {
 #        extraConfig = ''
 #           fastcgi_pass unix:${config.services.phpfpm.pools."www".socket};
 #           fastcgi_index index.php;
 #           include ${config.services.nginx.package}/conf/fastcgi_params;
 #           fastcgi_param SCRIPT_FILENAME $document_root#fastcgi_script_name;
 #        '';
 #      };
 #   };
 # };

  # Other configurations for PHP-FPM and system settings
 # services.phpfpm.pools."www" = {
 #    user = "www-data";
 #    group = "www-data";
 #    settings = {
 #       "pm" = "dynamic";
 #       "pm.max_children" = 5;
 #       "pm.start_servers" = 2;
 #       "pm.min_spare_servers" = 1;
 #       "pm.max_spare_servers" = 3;
 #    };
 # };

 # system.activationScripts.setup = ''
 #     mkdir -p /var/www
 #     chmod 755 /var/www
 #     groupadd -r www-data || true
 #     useradd -r -g www-data www-data || true
 #     chown -R www-data:www-data /var/www
 # '';
  
 # services.nginx.virtualHosts."apisbot.ru".listen = [
 #    { addr = "0.0.0.0"; port = 443; ssl = true; }
 #    { addr = "[::]"; port = 443; ssl = true; }
 # ];

  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
  # Experimental settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "ru_RU.UTF-8";
    supportedLocales = [ "ru_RU.UTF-8/UTF-8" ];
  };

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  # https://gist.github.com/dipankardas011/1635e1ede79b98336a3c7d7a4ae3f865
  # Wallpapers: https://wallpapers.99px.ru/wallpapers/download/202187/

  #services.xserver = {
  #  enable = true;
  #  desktopManager = {xterm.enable=false;};
  #  displayManager = {
  #     defaultSession = "none+i3";
  #  };
  #  windowManager.i3 = {
  #     enable = true;
      #extraPackages = with pkgs; [
  #        dmenu
  #        i3status
  #        i3lock
  #        i3blocks
  #     ];
  #  };
  #};
  
  #i3wm
  #services.xserver.windowManager.i3.package = pkgs.i3-gaps;
  #programs.dconf.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  #services.displayManager.sddm.enable = true;
  #services.desktopManager.plasma6.enable = true;
  
  programs.hyprland = {
    enable = true;
    #xwayland.hidpi = true;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    #If your cursor becomes invisible
    WLR_NO_HARDWARE_CURSORS = "1";
    #Hint Electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  hardware = {
    #OpenGL
    opengl.enable = true;

    #For most wayland compositors
    nvidia.modesetting.enable = true;
  };

  #Screensharing
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };
  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zorg = {
    isNormalUser = true;
    description = "zorg";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  kdePackages.kate
       thunderbird
       docker
       alacritty
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;
  

  programs.nix-ld.enable = true;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     #Web browsers
     ungoogled-chromium
     librewolf
     google-chrome
     chromedriver

     #Notification daemon
     dunst
     libnotify

     #Version control
     git

     #Command line
     fastfetch
     btop
     tree
     wget
     curl
     cmatrix
     htop
     tmux
     starfetch    
 
     #Terminal emulators
     kitty
     foot
     fish
     xonsh
    
     #Code editors
     zed-editor
     vscode
     neovim
     helix
     vim
     #code-cursor-fhs
     code-cursor

     #Utilities
     libclang
     dmenu
     busybox
     scdoc
     mpv
     xfce.thunar
     gcc 

     #Networking
     networkmanagerapplet
     tun2socks
     nginx
     clash-verge-rev
     amnezia-vpn

     #Fonts
     #terminus-nerdfont

     #Apps
     telegram-desktop
     wineWowPackages.stable
     anilibria-winmaclinux
     graphviz
     libreoffice-qt6-fresh
     
     #Games
     openmw
     bsdgames

     #App launchers
     rofi-wayland
     wofi

     #Hyprland
     hyprland
     swww
     xdg-desktop-portal-gtk
     xdg-desktop-portal-hyprland
     xwayland
     waybar
     hyprpaper
     hyprshot

     #Wayland packages
     meson
     wayland-protocols
     wayland-utils
     wl-clipboard
     wlroots

     #Sound
     pavucontrol

     #Langs
     nodejs
     php
     #php84Packages.composer
  ];
  
  home-manager = {
     extraSpecialArgs = { inherit inputs; };
     users = {
        "zorg" = import ./home.nix;
     };
  };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };


  #fonts.fonts = with pkgs; [
  #  nerdfonts
  #  meslo-lgs-nf
  #];

  nixpkgs.overlays = [
    (self: super: {
      waybar = super.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true"];
      });
    })
  ];

  services.printing = {
    # run on first setup: sudo hp-setup -i -a
    enable  =  true;
    drivers = [ pkgs.hplipWithPlugin ];
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
#    services.picom = {
#    enable = true;
#    fade = true;
#    vSync = true;
#    shadow = true;
#    fadeDelta = 4 ;
#    inactiveOpacity = 0.8;
#    activeOpacity = 1;
#    backend = "glx";
#    settings = {
#      blur = {
	#method = "dual_kawase";
#	background = true;
#	strength = 5;
#      };
#    };
#  };
  system.stateVersion = "24.05"; # Did you read the comment?

}
