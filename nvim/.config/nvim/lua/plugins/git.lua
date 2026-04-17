return {
  -- Full lazygit TUI inside Neovim
  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>", desc = "LazyGit" },
    },
  },

  -- Beautiful side-by-side git diffs and file history
  {
    "sindrets/diffview.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>",            desc = "Diff view open" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>",   desc = "File history" },
      { "<leader>gD", "<cmd>DiffviewClose<cr>",           desc = "Diff view close" },
    },
  },
}
