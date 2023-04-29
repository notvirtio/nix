{ stdenv, gnumake, fetchFromGitHub }:
stdenv.mkDerivation rec {
  name = "Yuescript";
  version = "45c66c4b8ad0d34742ec7e7ea038cda8ddc0235e";

  src = fetchFromGitHub {
    owner = "pigpigyyy";
    repo = "Yuescript";
    rev = "${version}";
    sha256 = "YQz68Zb5QOlGe/14TMdaK9wwPMwM9gY6sTiDEZhoI4I=";
  };

  nativeBuildInputs = [ ];
  buildInputs = [ ];

  buildPhase = ''
    sed -i "s/\/bin\/bash/\/bin\/sh/g" makefile
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bin/release/yue $out/bin
  '';
}
