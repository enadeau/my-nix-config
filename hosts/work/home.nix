{inputs, ...}: {
  imports = [
    ../../homeManagerModules
  ];

  home = {
    username = "enadeau";
    homeDirectory = "/home/enadeau";
  };

  nixGL = {
    packages.nixGLIntel = inputs.nixgl.packages."x86_64-linux".nixGLIntel;
    defaultWrapper = "mesa";
  };
}
