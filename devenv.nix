{ inputs, pkgs, ... }:
let
  stable-pkgs = import inputs.nixpkgs-stable { system = pkgs.system; };
  mitogen-pkg = inputs.ansible-mitogen.defaultPackage.x86_64-linux;

  zabbix-api = with pkgs.python39.pkgs; buildPythonPackage rec {
    pname = "zabbix-api";
    version = "0.5.5";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-fnuEeSCQvTqlRvzLDhPIMNv+BDEwNQmwCfbSeDyiQY0=";
    };
  };

  py-zabbix = with pkgs.python39.pkgs; buildPythonPackage {
    pname = "py-zabbix";
    version = "1.7.7";
    format = "wheel";
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/22/27/b75d1433caf55d077efe0dfadf494a53000bfc4ea5a1c9f197a87a3cd428/py_zabbix-1.1.7-py3-none-any.whl";
      sha256 = "sha256-+SGryIKYxW9aq5BUgVEiypWfhhLfiP3DokCtLZXkwoI=";
    };
  };
in
{
  devcontainer.enable = true;
  packages = [
    stable-pkgs.ansible_2_9
    stable-pkgs.ansible-lint
    stable-pkgs.python39Packages.hvac
    stable-pkgs.python39Packages.pyvmomi
    stable-pkgs.python39Packages.distro
    zabbix-api
    py-zabbix
    (stable-pkgs.python39Packages.mitogen.overridePythonAttrs (old: rec {
      pname = "mitogen";
      version = "0.2.10";
      src = pkgs.fetchFromGitHub {
        owner = "mitogen-hq";
        repo = pname;
        rev = "v${version}";
        sha256 = "sha256-SFwMgK1IKLwJS8k8w/N0A/+zMmBj9EN6m/58W/e7F4Q=";
      };
    }))
    mitogen-pkg
    pkgs.cdrkit
    pkgs.sshpass
    pkgs.cowsay
    pkgs.lolcat
    pkgs.awscli
    pkgs.terraform
    pkgs.vault-bin
    stable-pkgs.azure-cli
    pkgs.azure-storage-azcopy
    pkgs.infracost
  ];
  env = {
    ANSIBLE_CONFIG = "${mitogen-pkg.outPath}/ansible.cfg";
  };
}
