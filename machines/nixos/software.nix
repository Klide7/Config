{ pkgs, ... }: {
  # pakete finden auf https://mynixos.com
  home-manager.users.klide.home.packages = with pkgs; [
    # minecraft stuff
    prismlauncher
    openjdk8
    openjdk17
    openjdk22
  ];
}
