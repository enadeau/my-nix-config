{
  lib,
  config,
  ...
}: {
  options = {
    vim.enable = lib.mkEnableOption "enable vim";
  };

  config = lib.mkIf config.vim.enable {
    programs.nixvim = {
      enable = true;
      type = "vim";
      extraFiles = {
        "queries/python/folds.scm".source = ./python_folds.scm;
      };
      extraConfigLua = ''
        vim.opt.runtimepath:prepend("/home/emilen/.config/nvim")
      '';

      globals = {
        mapleader = " ";
        maplocallader = "«";
      };

      opts = {
        showcmd = true; # Display the command being typed on the las line
        scrolloff = 3; # Number of line to show around the cursor
        updatetime = 100; # Fast completion
        autoread = true; # Refresh file if only edited outside of vim
        swapfile = false; # Disable swap file
        undofile = true; # Save and restore undo history
        # Line number
        number = true; # Display current line number on the left
        relativenumber = true; # Display relative line number on the left
        # Tab
        expandtab = true; # Replace tab with spaces in insert mode
        shiftwidth = 4; # Number of space use for each step of (auto)indent
        softtabstop = 4; # Number of space tab counts for when editing
        # Search
        hlsearch = true; # highlight search result
        ignorecase = true; # Use case insensitive when search query is lowercase
        smartcase = true; # Use case sensitive search when search query is not lowercase
      };

      keymaps = [
        {
          action = ":set cursorline! cursorcolumn!<CR>";
          key = "<Leader>c";
          mode = ["n"];
        }
      ];

      autoCmd = [
        {
          desc = "Remove trailing space at end of line when saving";
          callback = {
            __raw = ''
              function(ev)
                  save_cursor = vim.fn.getpos(".")
                  vim.cmd([[%s/\s\+$//e]])
                  vim.fn.setpos(".", save_cursor)
              end'';
          };
          event = ["BufWritePre"];
          pattern = "*";
        }
      ];

      plugins = {
        lualine = {
          enable = true;
          iconsEnabled = true;
        };
        comment.enable = true;
        cmp = {
          enable = true;
          settings.sources = [
            {name = "nvim_lsp";}
            {name = "buffer";}
          ];
        };
        cmp-nvim-lsp.enable = true;
        cmp-buffer.enable = true;
        lsp = {
          enable = true;
          keymaps = {
            diagnostic = {
              "<Leader>k" = "goto_prev";
              "<Leader>j" = "goto_next";
            };
            lspBuf = {
              "<Leader>r" = "rename";
              "<Leader>a" = "code_action";
              "gd" = "definition";
              "gD" = "declaration";
              "gI" = "implementation";
              "<Leader>D" = "type_definition";
              "K" = "hover";
              "<Leader>f" = "format";
            };
          };
          servers = {
            nixd = {
              enable = true;
              extraOptions.settings.nixd.formatting.command = ["alejandra"];
            };
          };
        };
        telescope = {
          enable = true;
          keymaps = {"<C-p>" = "git_files";};
        };
        treesitter = {
          enable = true;
          folding = true;
          settings.highlight.enable = true;
        };
      };
    };
  };
}
