{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bc
    firefox
  ];
}
