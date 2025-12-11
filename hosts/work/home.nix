{inputs, ...}: {
  imports = [
    ../../homeManagerModules
  ];

  home = {
    username = "enadeau";
    homeDirectory = "/home/enadeau";
  };

  targets.genericLinux.nixGL = {
    packages.nixGLIntel = inputs.nixgl.packages."x86_64-linux".nixGLIntel;
    defaultWrapper = "mesa";
  };
}
