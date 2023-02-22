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

  molecule = with python-pkgs; buildPythonPackage rec {
    pname = "molecule";
    version = "4.0.4";
    format = "pyproject";
    src = super.fetchFromGitHub {
      owner = "ansible-community";
      repo = pname;
      rev = "v${version}";
      sha256 = "sha256-rnN/ITMKuQIWpn8hkD+qYcrB9PqLsM52BDuQ9j7Eqyw=";
    };
    doCheck = false;
    makeWrapperArgs = [ "--unset PYTHONPATH" ];
    propagatedBuildInputs = [
      setuptools
      click-help-colors
      jinja2
      enrich
      jsonschema
      packaging
      pluggy
      pyyaml
      rich
      cookiecutter
      ansible-compat
      ansible-core
    ];
  };

  ansible-lint = super.python310Packages.ansible-lint.overridePythonAttrs (old: {
    makeWrapperArgs = [ "--unset PYTHONPATH" ];
  });
}
