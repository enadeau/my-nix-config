{pkgs, completionDir, ...}:

let
  # Path where the completion script will be saved
  maestralCompletion = pkgs.runCommand "maestral-completion" {
    buildInputs = [ pkgs.maestral ];
  } ''
    ${pkgs.maestral}/bin/maestral completion bash > $out
  '';
in
{
  home.packages = [
    pkgs.maestral
  ];

  systemd.user.services.maestral = {
    Unit = {
      Description = "Maestral Dropbox Client";
    };

    Service = {
      Type = "notify";
      NotifyAccess = "exec";
      ExecStart = "${pkgs.maestral}/bin/maestral start --foreground";
      ExecStop = "${pkgs.maestral}/bin/maestral stop";
      # Restart = "on-failure";
      # ExecStopPost= "${pkgs.bash}/bin/env bash -c \"if [ \${SERVICE_RESULT} != success ]; then notify-send Maestral 'Daemon failed'; fi\"";
      WatchdogSec = "30s";
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  home.file."${completionDir}/maestral".source = "${maestralCompletion}";
}
