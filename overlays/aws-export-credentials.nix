self: super: {
  aws-export-credentials = super.python3Packages.buildPythonApplication rec {
    pname = "aws-export-credentials";
    version = "0.18.0";
    pyproject = true;

    src = super.fetchPypi {
      inherit version;
      pname = "aws_export_credentials";
      hash = "sha256-6Xeh3uYcJmUzSc8VQI9SEo/2cis94BlK3STXRHf5oM8=";
    };

    # Patch pyproject.toml to use modern poetry-core backend instead of
    # the deprecated poetry.masonry.api, and to avoid requiring the full
    # Poetry CLI (only poetry-core is available in nixpkgs).
    postPatch = ''
      substituteInPlace pyproject.toml \
        --replace 'poetry.masonry.api' 'poetry.core.masonry.api' \
        --replace 'poetry>=' 'poetry-core>='
    '';

    build-system = [
      super.python3Packages.poetry-core
    ];

    dependencies = [
      super.python3Packages.boto3
    ];
  };
}
