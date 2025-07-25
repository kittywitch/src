{pkgs}:
pkgs.mkShell {
  packages = with pkgs; [
    fetchdps
    pkgs.nur.repos.ihaveamac._3dstools
    pkgs.nur.repos.ihaveamac._3dstool
    pkgs.nur.repos.ihaveamac._3dslink
  ];
}
