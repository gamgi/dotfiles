{ pkgs, ... }:

let
  extensions = (with pkgs.vscode-extensions; [
    bbenoist.nix
    dbaeumer.vscode-eslint
    eamodio.gitlens
    hashicorp.terraform
    ms-python.python
    matklad.rust-analyzer
    vscodevim.vim
    # ms-azuretools.vscode-docker
  ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "remote-ssh-edit";
      publisher = "ms-vscode-remote";
      version = "0.47.2";
      sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
    }
    {
		  name = "vscode-styled-jsx-syntax";
		  publisher = "divlo";
		  version = "1.3.1";
	    sha256 = "047aqm4c2y3m3yx3vrz5d2lyr5rwyh4b2w8pf22rqw03bza8i1ga";
	  }
    {
    name = "vsc-community-material-theme";
    publisher = "equinusocio";
    version = "1.4.4";
    sha256 = "005l4pr9x3v6x8450jn0dh7klv0pv7gv7si955r7b4kh19r4hz9y";
		}
		{
		  name = "vsc-material-theme";
		  publisher = "equinusocio";
		  version = "33.2.2";
		  sha256 = "0a55ksf58d4fhk1vgafibxkg61rhyd6cl10wz9gwg22rykx6i8d9";
		}
		{
		  name = "vsc-material-theme-icons";
		  publisher = "equinusocio";
		  version = "2.2.1";
		  sha256 = "03mxvm8c9zffzykc84n2y34jzl3l7jvnsvnqwn6gk9adzfd2bh41";
		}
  ];
in
{
  vscodium-with-extensions = pkgs.vscode-with-extensions.override {
    vscode = pkgs.vscodium;
    vscodeExtensions = extensions;
  };
}
