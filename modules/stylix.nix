{ pkgs, ... }:
{
  stylix = {
    enable = true;
    image = pkgs.fetchurl {
      url = "https://images-assets.nasa.gov/image/carina_nebula/carina_nebula~large.jpg";
      hash = "sha256-6Ew/BAdPMrramdVMfVuGMrumh+0oeFBnS80mppK+NL0=";
    };
    polarity = "dark";
  };
}
