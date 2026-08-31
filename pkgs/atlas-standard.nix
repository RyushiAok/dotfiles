{
  lib,
  stdenvNoCC,
  fetchurl,
}:

let
  version = "1.3.2";
  sources = {
    x86_64-linux = {
      suffix = "linux-amd64";
      hash = "sha256-l1XVRIbffuyL4zet7HZE3yxXJldWYIyfCz6al5Sjx3Q=";
    };
    aarch64-darwin = {
      suffix = "darwin-arm64";
      hash = "sha256-gVN1eBXTF4EFW7uX3R6lypgfReqPVfvJg9D0KXI+rlc=";
    };
  };
  source =
    sources.${stdenvNoCC.hostPlatform.system}
      or (throw "atlas-standard: unsupported system ${stdenvNoCC.hostPlatform.system}");
in
stdenvNoCC.mkDerivation {
  pname = "atlas-standard";
  inherit version;

  src = fetchurl {
    url = "https://release.ariga.io/atlas/atlas-${source.suffix}-v${version}";
    inherit (source) hash;
  };

  dontUnpack = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 "$src" "$out/bin/atlas"

    runHook postInstall
  '';

  meta = {
    description = "Atlas CLI standard distribution";
    homepage = "https://atlasgo.io/";
    license = lib.licenses.unfreeRedistributable;
    mainProgram = "atlas";
    platforms = builtins.attrNames sources;
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
