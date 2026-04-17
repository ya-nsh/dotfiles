return {
  -- Replace cmdline, messages, and popups with slick UI
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
    },
  },

  -- Smooth cursor and scroll animations
  {
    "echasnovski/mini.animate",
    event = "VeryLazy",
    opts = {
      scroll = { enable = true },
      cursor = { enable = true },
      resize = { enable = true },
      open = { enable = false },
      close = { enable = false },
    },
  },

  -- VS Code-style breadcrumb in the winbar
  {
    "Bekaboo/dropbar.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-telescope/telescope-fzf-native.nvim" },
    opts = {},
  },

  -- Decorations in the scrollbar (git, diagnostics, search)
  {
    "lewis6991/satellite.nvim",
    event = "BufReadPost",
    opts = {},
  },
}
