{ lib, stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  pname = "bb-kde-theme";
  version = "123";

  src = self;

  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    description = "A port of the arc theme for Plasma";
    homepage = "https://git.io/arc-kde";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
  };
}