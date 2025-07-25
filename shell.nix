{pkgs}: let
  inherit (pkgs) lib;
  inherit (lib.meta) getExe;
in pkgs.mkShell {
  shellHook = ''
    ${getExe pkgs.toilet} --gay --font mono9 "~/src"
  '';
  packages = with pkgs; [
    fetchdps
    katgba-emu
    pkgs.nur.repos.ihaveamac._3dstools
    pkgs.nur.repos.ihaveamac._3dstool
    pkgs.nur.repos.ihaveamac._3dslink
  ];
}
