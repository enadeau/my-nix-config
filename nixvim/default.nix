{
  # colorschemes.base16.enable = true;
  # colorschemes.base16.colorscheme = "solarized-dark";
  colorschemes.gruvbox.enable = true;

  extraFiles = {
    "queries/python/folds.scm".source = ./python_folds.scm;
    "lua/focus_line.lua".source = ./focus_line.lua;
  };
  extraConfigLua = ''
    vim.opt.runtimepath:prepend("/home/emilen/.config/nvim")
    require("focus_line")
  '';

  globals = {
    mapleader = " ";
    maplocalleader = "«";
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
    cursorline = true;
    cursorcolumn = true;
  };

  keymaps = [
    {
      options.desc = "Toogle highlight of current line and column";
      key = "<Leader>c";
      mode = ["n"];
      options.unique = true;
      action = ":set cursorline! cursorcolumn!<CR>";
    }
    {
      options.desc = "Exit normal mode";
      key = "jj";
      mode = ["i"];
      options.unique = true;
      action = "<Esc>";
    }
    {
      options.desc = "Save";
      key = "<Leader>w";
      mode = ["n"];
      options.unique = true;
      action = ":w<CR>";
    }
    {
      options.desc = "Toogle fold";
      key = "<Leader><Space>";
      mode = ["n"];
      options.unique = true;
      action = "za";
    }
    {
      options.desc = "Focus the current line";
      key = "<Leader>f";
      mode = ["n"];
      options.unique = true;
      action = ":lua FocusCurrentLine()<CR>";
    }
    {
      options.desc = "Next in snippet";
      key = "<C-j>";
      mode = ["i"];
      options.unique = true;
      action.__raw = ''
        function()
          require("luasnip").jump(1)
        end
      '';
    }
    {
      options.desc = "Prev in snippet";
      key = "<C-k>";
      mode = ["i"];
      options.unique = true;
      action.__raw = ''
        function()
          require("luasnip").jump(-1)
        end
      '';
    }
    {
      options.desc = "Change string in f-string";
      key = "<C-f>";
      mode = ["i"];
      options.unique = true;
      action = ''<c-g>u<Esc>mPF"if<Esc>`Pa<c-g>u<Right>'';
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
      settings.options.icons_enabled = true;
    };
    comment.enable = true;
    gitsigns = {
      enable = true;
      settings.current_line_blame = true;
    };
    luasnip.enable = true;
    friendly-snippets.enable = true;
    cmp = {
      enable = true;
      settings.sources = [
        {name = "nvim_lsp";}
        {name = "buffer";}
        {name = "luasnip";}
        {name = "path";}
      ];
      settings.mapping = {
        "<C-e>" = "cmp.mapping.close()";
        "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
        "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        "<CR>" = "cmp.mapping.confirm({ select = true })";
      };
    };
    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    cmp_luasnip.enable = true;
    cmp-path.enable = true;
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
          "<localleader>f" = "format";
        };
      };
      servers = {
        nixd.enable = true;
        pylsp = {
          enable = true;
          settings.plugins = {
            jedi.enable = true;
          };
        };
        ruff.enable = true;
        lua_ls.enable = true;
        terraformls.enable = true;
        ts_ls.enable = true;
      };
    };
    lspkind = {
      enable = true;
      cmp = {
        enable = true;
        menu = {
          nvim_lsp = "[LSP]";
          path = "[path]";
          luasnip = "[snip]";
          buffer = "[buffer]";
        };
      };
    };
    none-ls = {
      enable = true;
      sources.formatting.alejandra.enable = true;
    };
    telescope = {
      enable = true;
      keymaps = {
        "<Leader>pp" = "git_files";
        "<Leader>pa" = "find_files";
        "<Leader>pg" = "live_grep";
        "<Leader>pb" = "buffers";
      };
    };
    web-devicons.enable = true;
    treesitter = {
      enable = true;
      folding = true;
      settings.highlight.enable = true;
    };
  };
}
