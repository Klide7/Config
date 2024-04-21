{ self, pkgs, ... }: {
  # nix-locate as command-not-found replacement
  imports = [ self.inputs.nix-index-database.nixosModules.nix-index ];
  programs.command-not-found.enable = false;

  services = {
    dbus.packages = [ pkgs.gcr ]; # for GPG key prompt

    # console greeter
    greetd = {
      enable = true;
      restart = true;
      vt = 7;
      settings.default_session.command =
        "${pkgs.greetd.tuigreet}/bin/tuigreet -tr --remember-user-session";
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
  };

  fonts = {
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "Iosevka" ]; })
      noto-fonts
      noto-fonts-emoji
    ];

    fontconfig.defaultFonts = {
      emoji = [ "Noto Color Emoji" ];
      monospace = [ "IosevkaNerdFont" ];
      sansSerif = [ "Noto Sans" ];
      serif = [ "Noto Serif" ];
    };
  };

  home-manager.users.klide = hm: {
    home = {
      # a cursor theme is required for virt-manager
      pointerCursor = {
        name = "Vanilla-DMZ";
        package = pkgs.vanilla-dmz;
        gtk.enable = true;
      };

      sessionVariables = {
        GTK_THEME = "Adwaita:dark";

        # make stuff use wayland
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        SDL_VIDEODRIVER = "wayland";

        # apparently needed for java on tiling WMs
        _JAVA_AWT_WM_NONREPARENTING = "1";

        # nvida stuff
        LIBVA_DRIVER_NAME = "nvidia";
        XDG_SESSION_TYPE = "wayland";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        WLR_NO_HARDWARE_CURSORS = "1";
      };

      packages = with pkgs; [
        grim
        libnotify
        self.inputs.obscura.packages.${system}.flameshot-fixed
        xdg_utils
      ];
    };

    qt = {
      enable = true;
      platformTheme = "gtk";
      style.name = "Adwaita-Dark";
    };

    services = {
      # gpg-agent GUI should use GTK3
      gpg-agent = {
        enable = true;
        pinentryPackage = pkgs.pinentry-gnome3;
      };
    };

    programs = {
      feh.enable = true;
      mpv.enable = true;
      yt-dlp.enable = true;
      zathura.enable = true;

      firefox = {
        enable = true;
        package = pkgs.firefox.override {
          cfg.speechSynthesisSupport = false;
        };
      };
    };
  };
}
