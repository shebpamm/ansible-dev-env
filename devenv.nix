{ inputs, pkgs, ... }:
let
  wrapMitogen = inputs.ansible-mitogen.wrapMitogen.${pkgs.system};
  patched-pkgs = pkgs.extend (import ./packages.nix);
in
{
  languages.python.enable = true;
  packages = with patched-pkgs; [
    (wrapMitogen ansible_2_9)
    ansible-lint
    mitogen
  ];
}
