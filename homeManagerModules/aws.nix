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
  };
}
