{ self, pkgs, lib, ... }: {
  imports = [ "${self}/rice" ];

  ##### basic #####

  aquaris = {
    filesystem = { filesystem, zpool, ... }: {
      disks."/dev/disk/by-id/nvme-eui.002538899103d911".partitions = [
        { content = zpool (p: p.rpool); }
      ];
      zpools.rpool.datasets = {
        "nixos/nix" = { };
        "nixos/persist".options."com.sun:auto-snapshot" = "true";
        "nixos/home/klide".options."com.sun:auto-snapshot" = "true";
      };
    };

    persist.system = [
      "/etc/NetworkManager/system-connections"
      "/var/cache/tuigreet"
      "/var/lib/NetworkManager"
      "/var/lib/libvirt"
      "/var/lib/systemd"
    ];
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-id/nvme-uuid.ed847e9c-8b38-4a5d-b00f-e946f9a4ca23-part1";
    };
  };

  boot = {
    lanzaboote.enable = lib.mkForce false;
    loader = {
      timeout = lib.mkForce 5;

      systemd-boot = {
        enable = lib.mkOverride 0 true;
        memtest86.enable = true;
        netbootxyz.enable = true;
      };
    };
  };

  ##### nvidia #####

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "nvidia-settings"
    "nvidia-x11"
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.opengl.driSupport32Bit = true;
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
  };

  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  ##### misc system #####

  nix.gc.automatic = true;
  system.activationScripts.gc-generations.text = ''
    ${pkgs.nix}/bin/nix-env                  \
      --profile /nix/var/nix/profiles/system \
      --delete-generations +5
  '';

  services.zfs.autoSnapshot.enable = true;
  services.flatpak.enable = true;

  systemd.coredump.enable = false;

  ##### virtualisation #####

  users.users.klide.extraGroups = [ "libvirtd" ];
  home-manager.users.klide.home.packages = [ pkgs.virt-manager ];

  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu.swtpm.enable = true;
  };

  networking.firewall.trustedInterfaces = [ "virbr0" ];
}
