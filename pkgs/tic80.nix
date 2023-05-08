{ lib, pkgs, stdenv, fetchgit, libGL, alsa-lib, libX11, xorgproto, libICE, libXi
, libXScrnSaver, libXcursor, libXinerama, libXext, libXxf86vm, libXrandr
, libxkbcommon, wayland, wayland-protocols, wayland-scanner, dbus, udev
, libdecor, pipewire, libpulseaudio, libiconv, withPro ? true, ... }:
with pkgs;
let
  major = "1";
  minor = "0";
  revision = "2164";
in stdenv.mkDerivation rec {
  pname = "tic-80";
  version = "${major}.${minor}.${revision}";

  src = fetchgit {
    url = "https://github.com/nesbox/TIC-80";
    rev = "v" + version;
    sha256 = "sha256-SnaAhdYoblxKlzTSyfcnvY6u7X6aIJIYWZAXtL2IIXc=";
    fetchSubmodules = true;
  };

  # TIC-80's version detection depends on the git checkout remaining intact
  # verbatim.  It appears fetchgit does weird things, even with leaveDotGit =
  # true (which implies deepClone).  Here we take a different approach and
  # hardcode the version in CMakeLists.txt.
  postUnpack = ''
    sed -E -i"" \
        -e 's|VERSION_MAJOR [^)]+|VERSION_MAJOR ${major}|' \
        -e 's|VERSION_MINOR [^)]+|VERSION_MINOR ${minor}|' \
        -e 's|VERSION_REVISION [^)]+|VERSION_REVISION ${revision}|' \
        TIC-80/CMakeLists.txt
  '';

  cmakeFlags = (if withPro then [ "-DBUILD_PRO=On" ] else [])
               ++ ["-DBUILD_SDLGPU=On"];
  enableParallelBuilding = true;
  dontStrip = true;
  buildInputs = [ cmake pkg-config wayland-protocols ] ++ dlopenBuildInputs;
  dlopenBuildInputs = [
    libGL
    libGLU
    alsa-lib
    libX11
    libICE
    libXi
    libXScrnSaver
    libXcursor
    libXinerama
    libXext
    libXxf86vm
    libXrandr
    wayland
    libxkbcommon
    wayland-scanner
    dbus
    udev
    libdecor
    pipewire
    libpulseaudio
  ];
  dlopenPropagatedBuildInputs = [ libGL libX11 ];
  propagatedBuildInputs = [ xorgproto ] ++ dlopenPropagatedBuildInputs;
  # buildInputs = [ libiconv ] ++ dlopenBuildInputs;
  # nativeBuildInputs = [  ];
  # propagatedBuildInputs = [ ];
  # buildInputs = [  ];

  # installPhase = ''
  # '';

  # SDL is weird in that instead of just dynamically linking with
  # libraries when you `--enable-*` (or when `configure` finds) them
  # it `dlopen`s them at runtime. In principle, this means it can
  # ignore any missing optional dependencies like alsa, pulseaudio,
  # some x11 libs, wayland, etc if they are missing on the system
  # and/or work with wide array of versions of said libraries. In
  # nixpkgs, however, we don't need any of that. Moreover, since we
  # don't have a global ld-cache we have to stuff all the propagated
  # libraries into rpath by hand or else some applications that use
  # SDL API that requires said libraries will fail to start.
  #
  # You can grep SDL sources with `grep -rE 'SDL_(NAME|.*_SYM)'` to
  # list the symbols used in this way.
  postFixup = let
    rpath =
      lib.makeLibraryPath (dlopenPropagatedBuildInputs ++ dlopenBuildInputs);
  in ''
    patchelf --set-rpath "$(patchelf --print-rpath $out/bin/tic80):${rpath}" "$out/bin/tic80"
  '';

  meta = with lib; {
    description =
      "A free and open source fantasy computer for making, playing and sharing tiny games";
    longDescription = ''
      TIC-80 is a free and open source fantasy computer for making, playing and
      sharing tiny games.
      There are built-in tools for development: code, sprites, maps, sound
      editors and the command line, which is enough to create a mini retro
      game. At the exit you will get a cartridge file, which can be stored and
      played on the website.
      Also, the game can be packed into a player that works on all popular
      platforms and distribute as you wish. To make a retro styled game the
      whole process of creation takes place under some technical limitations:
      240x136 pixels display, 16 color palette, 256 8x8 color sprites, 4
      channel sound and etc.
    '';
    homepage = "https://github.com/nesbox/TIC-80/";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ winny ];
  };
}
