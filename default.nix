{ lib, stdenv, fetchFromGitHub, pkgs }:

stdenv.mkDerivation rec {
  pname = "bb-kde-theme";
  version = "123";

  nativeBuildInputs = with pkgs; [ imagemagick ];

  src = ./.;

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "A port of the arc theme for Plasma";
    homepage = "https://git.io/arc-kde";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
}