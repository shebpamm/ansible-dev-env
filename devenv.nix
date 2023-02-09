{ inputs, pkgs, ... }:
let
  mitogen-pkg = inputs.ansible-mitogen.defaultPackage.x86_64-linux;
  patched-pkgs = pkgs.extend (import ./packages.nix);
in
{
  devcontainer.enable = true;
  languages.python.enable = true;
  languages.python.package = pkgs.python310;
  packages = with patched-pkgs; [
    ansible_2_9
    python310Packages.hvac
    python310Packages.pyvmomi
    python310Packages.distro
    ansible-lint
    zabbix-api
    py-zabbix
    mitogen-pkg
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
  env = {
    ANSIBLE_CONFIG = "${mitogen-pkg.outPath}/ansible.cfg";
  };
}
