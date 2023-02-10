self: super:
let
  python-pkgs = super.python310.pkgs;
in
{
  ansible_2_9 = with python-pkgs; buildPythonPackage
    rec {
      pname = "ansible";
      version = "2.9.27";

      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-R5FZ5Qs72Qkg0GvFlBDDpR0/m+m04QKeEdHkotBwVzY=";
      };

      prePatch = ''
        # ansible-connection is wrapped, so make sure it's not passed
        # through the python interpreter.
        sed -i "s/\[python, /[/" lib/ansible/executor/task_executor.py
      '';

      postInstall = ''
        for m in docs/man/man1/*; do
          install -vD $m -t $out/share/man/man1
        done
      '';

      propagatedBuildInputs = [
        pycrypto
        paramiko
        jinja2
        pyyaml
        httplib2
        six
        netaddr
        dnspython
        jmespath
        dopy
        ncclient
      ];

      # dificult to test
      doCheck = false;

      meta = with lib; {
        homepage = "https://www.ansible.com";
        description = "Radically simple IT automation";
        license = [ licenses.gpl3 ];
        maintainers = with maintainers; [ joamaki costrouc hexa ];
        platforms = platforms.linux ++ platforms.darwin;
      };
    };

  zabbix-api = with python-pkgs;
    buildPythonPackage rec {
      pname = "zabbix-api";
      version = "0.5.5";
      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-fnuEeSCQvTqlRvzLDhPIMNv+BDEwNQmwCfbSeDyiQY0=";
      };
    };

  py-zabbix = with python-pkgs; buildPythonPackage {
    pname = "py-zabbix";
    version = "1.7.7";
    format = "wheel";
    src = pkgs.fetchurl {
      url = "https://files.pythonhosted.org/packages/22/27/b75d1433caf55d077efe0dfadf494a53000bfc4ea5a1c9f197a87a3cd428/py_zabbix-1.1.7-py3-none-any.whl";
      sha256 = "sha256-+SGryIKYxW9aq5BUgVEiypWfhhLfiP3DokCtLZXkwoI=";
    };
  };

  ansible-lint = super.python310Packages.ansible-lint.overridePythonAttrs (old: rec {
    version = "4.3.1";
    pname = "ansible-lint";
    postPatch = "";
    src = python-pkgs.fetchPypi {
      inherit pname version;
      hash = "sha256-994JckNq5D0ogcfCNdkI5ybhRkcXeyQ5BkB1J2J5+MQ=";
    };
  });

  mitogen = super.python310Packages.mitogen.overridePythonAttrs (old: rec {
    pname = "mitogen";
    version = "0.2.10";
    src = super.fetchFromGitHub {
      owner = "mitogen-hq";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-SFwMgK1IKLwJS8k8w/N0A/+zMmBj9EN6m/58W/e7F4Q=";
    };
  });
}
