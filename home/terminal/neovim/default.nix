{ config, pkgs, programs, home, ... }:

{
  home.sessionVariables = {
    EDITOR = "nvim";
    SUDO_EDITOR = "nvim";
  };
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = ''
      require('plugins')
      require('opts')
      vim.cmd([[
        loader.enable()
	set signcolumn=yes
      ]])
    '';
    plugins = with pkgs.vimPlugins; [
      
    ];
  };
}
