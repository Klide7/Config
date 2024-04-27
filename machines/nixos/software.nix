{ pkgs, ... }: {
  # pakete finden auf https://mynixos.com
  home-manager.users.klide.home.packages = with pkgs; [
    prismlauncher
  ];
}
