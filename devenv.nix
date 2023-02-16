{ inputs, pkgs, ... }:
let
  wrapMitogen = inputs.ansible-mitogen.wrapMitogen.${pkgs.system};
  patched-pkgs = pkgs.extend (import ./packages.nix);
in
{
  devcontainer.enable = true;
  languages.python.enable = true;
  languages.python.package = pkgs.python310.withPackages (ps: with ps;
    [
      requests
    ]
  );
  packages = with patched-pkgs; [
    (wrapMitogen ansible_2_9)
    python310Packages.hvac
    python310Packages.pyvmomi
    python310Packages.distro
    ansible-modules-hashivault
    ansible-lint
    zabbix-api
    py-zabbix
    cdrkit
    sshpass
    cowsay
    lolcat
    awscli
    terraform
    vault-bin
    azure-cli
    azure-storage-azcopy
    infracost
  ];
  env = { };
}
