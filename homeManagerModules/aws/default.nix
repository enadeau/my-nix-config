{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    aws.enable = lib.mkEnableOption "enable aws";
  };

  config = lib.mkIf config.aws.enable {
    programs.bash.initExtra = ''
      function sso (){
        export AWS_PROFILE=$1-$2
        ${pkgs.aws-sso-util}/bin/aws-sso-util login --profile $AWS_PROFILE
        $(${pkgs.aws-export-credentials}/bin/aws-export-credentials --profile $AWS_PROFILE --credentials-file-profile $AWS_PROFILE)
      }
    '';

    programs.awscli.enable = true;
    programs.granted.enable = true;
    # Make assume export the creds as env variables
    home.shellAliases = {
      assume = ". assume";
    };
    home.packages = [
      (
        pkgs.stdenv.mkDerivation {
          name = "tunnel";
          src = ./.;
          nativeBuildInputs = [pkgs.makeWrapper];
          installPhase = ''
            mkdir -p $out/bin
            cp ./tunnel.sh $out/bin/tunnel
            chmod +x $out/bin/tunnel
          '';
          postFixup = ''
            wrapProgram $out/bin/tunnel --set PATH ${lib.makeBinPath [pkgs.awscli pkgs.ssm-session-manager-plugin]}
          '';
        }
      )
    ];
  };
}
