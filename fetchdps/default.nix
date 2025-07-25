{ writeShellScriptBin, lib, jq, curl }:
  writeShellScriptBin "fetchdps" ''
    export PATH="$PATH:${lib.makeBinPath [
      jq
      curl
    ]}"
    exec ${./fetchdps.sh} "$@"
  ''
