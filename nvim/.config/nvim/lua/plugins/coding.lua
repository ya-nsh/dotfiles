return {
  -- Add/change/delete surrounding brackets, quotes, tags
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {},
  },

  -- Pretty diagnostics, references, quickfix list (already in vscode-feel.lua but extended here)
  {
    "folke/trouble.nvim",
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",                        desc = "Diagnostics" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",           desc = "Buffer diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>",                desc = "Symbols" },
      { "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP definitions" },
      { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",                             desc = "Quickfix" },
    },
  },

  -- Run tests and see results inline
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/nvim-nio",
      "nvim-neotest/neotest-jest",
    },
    keys = {
      { "<leader>tn", "<cmd>lua require('neotest').run.run()<cr>",                  desc = "Run nearest test" },
      { "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "Run file tests" },
      { "<leader>ts", "<cmd>lua require('neotest').summary.toggle()<cr>",           desc = "Test summary" },
      { "<leader>to", "<cmd>lua require('neotest').output_panel.toggle()<cr>",      desc = "Test output" },
    },
    opts = {
      adapters = {
        ["neotest-jest"] = {
          jestCommand = "bun test",
        },
      },
    },
  },

  -- Task runner with output panels
  {
    "stevearc/overseer.nvim",
    keys = {
      { "<leader>ot", "<cmd>OverseerToggle<cr>",  desc = "Task list" },
      { "<leader>or", "<cmd>OverseerRun<cr>",     desc = "Run task" },
      { "<leader>ob", "<cmd>OverseerBuild<cr>",   desc = "Build task" },
    },
    opts = {},
  },
}
