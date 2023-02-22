self: super:
let
  python-pkgs = super.python310.pkgs;
in
rec {
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

  molecule = with python-pkgs; buildPythonApplication
    rec {
      pname = "molecule";
      version = "5.0.0a0";
      format = "pyproject";

      src = super.fetchFromGitHub {
        owner = "ansible-community";
        repo = "molecule";
        rev = "v${version}";
        hash = "sha256-bWJ+mMZvsrNzWkgzfurK/X3nXJeW+OqOUGM2VZ8srWg=";
      };

      nativeBuildInputs = [
        setuptools
        setuptools_scm
      ];

      propagatedBuildInputs = [
        # molecule-plugins
        jinja2
        pyyaml
        ansible-compat
        ansible-core
        click
        click-help-colors
        cookiecutter
        enrich
        jsonschema
        packaging
        pluggy
        rich
      ];

      passthru.optional-dependencies = {
        docs = [
          argparse-manpage
          cairosvg
          markdown-include
          mkdocs
          mkdocs-git-revision-date-localized-plugin
          mkdocs-material
          mkdocs-material-extensions
          mkdocs-multirepo-plugin
          mkdocstrings
          pillow
          pymdown-extensions
        ];
        lint = [
          check-jsonschema
          flake8
          jsonschema
          pre-commit
          yamllint
        ];
        test = [
          ansi2html
          ansible-lint
          coverage
          filelock
          pexpect
          pytest
          pytest-mock
          pytest-plus
          pytest-testinfra
          pytest-xdist
        ];
      };

      pythonImportsCheck = [ "molecule" ];
      makeWrapperArgs = [ "--unset PYTHONPATH" ];

      meta = with lib; {
        description = "Molecule aids in the development and testing of Ansible roles";
        homepage = "https://github.com/ansible-community/molecule";
        license = licenses.mit;
        maintainers = with maintainers; [ ];
      };
    };

  molecule-full = molecule.overridePythonAttrs (old: {
    makeWrapperArgs = [ "--set PYTHONPATH ${molecule-plugins}/lib/python3.10/site-packages" ];
  });

  molecule-plugins = with python-pkgs; buildPythonApplication rec {
    pname = "molecule-plugins";
    version = "23.0.0";
    format = "pyproject";

    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-mHXODJRikvnm2IUTm4BhskCpZvllI80OMw6Z4OxjGyk=";
    };

    nativeBuildInputs = [
      setuptools
      setuptools_scm
    ];

    propagatedBuildInputs = [
      molecule
    ];

    passthru.optional-dependencies = {
      docker = [
        docker
        requests
        selinux
      ];
      podman = [
        selinux
      ];
      test = [
        molecule
        pytest-helpers-namespace
      ];
    };

    # pythonImportsCheck = [ "molecule-plugins" ];

    meta = with lib; {
      description = "Collection on molecule plugins";
      homepage = "https://github.com/ansible-community/molecule-plugins";
      license = licenses.mit;
      maintainers = with maintainers; [ ];
    };
  };

  ansible-lint = super.python310Packages.ansible-lint.overridePythonAttrs (old: {
    makeWrapperArgs = [ "--unset PYTHONPATH" ];
  });
}
