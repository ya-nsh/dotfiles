return {
  -- Multi-cursor (Ctrl+D like VSCode)
  {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
      vim.g.VM_maps = {
        ["Find Under"] = "<C-d>",
        ["Find Subword Under"] = "<C-d>",
      }
    end,
  },

  -- File explorer (like VSCode sidebar) — already in LazyVim via neo-tree
  -- Ensure it opens with Ctrl+B
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<C-b>", "<cmd>Neotree toggle<cr>", desc = "Toggle file explorer" },
    },
  },

  -- Fuzzy finder (Ctrl+P like VSCode)
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<C-p>", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<C-S-f>", "<cmd>Telescope live_grep<cr>", desc = "Search in files" },
      { "<C-t>", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Go to symbol" },
    },
  },

  -- Better diagnostics panel (like VSCode Problems panel)
  {
    "folke/trouble.nvim",
    keys = {
      { "<C-S-m>", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle problems panel" },
    },
  },

  -- Git blame inline (like Cursor/GitLens)
  {
    "f-person/git-blame.nvim",
    event = "BufReadPre",
    opts = {
      enabled = true,
      message_template = "  <author> • <date> • <summary>",
      date_format = "%Y-%m-%d",
      virtual_text_column = 1,
    },
  },

  -- Indent guides (like VSCode)
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = true },
    },
  },

  -- Breadcrumbs / winbar (like VSCode top bar)
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
  },

  -- Auto-close brackets/quotes like VSCode
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- Better buffer tabs (like VSCode tabs)
  {
    "akinsho/bufferline.nvim",
    opts = {
      options = {
        close_command = "bd %d",
        right_mouse_command = "bd %d",
        diagnostics = "nvim_lsp",
        show_buffer_close_icons = true,
        show_close_icon = false,
        separator_style = "thin",
      },
    },
  },
}
