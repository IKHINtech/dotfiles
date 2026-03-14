return {
  "ishiooon/codex.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = function(_, opts)
    vim.schedule(function()
      require("codex").setup(opts)
    end)
  end,
  keys = {
    { "<leader>cc", "<cmd>Codex<cr>", desc = "Codex: Toggle" },
    { "<leader>cf", "<cmd>CodexFocus<cr>", desc = "Codex: Focus" },
    { "<leader>cs", "<cmd>CodexSend<cr>", mode = "v", desc = "Codex: Send selection" },
    {
      "<leader>cs",
      "<cmd>CodexTreeAdd<cr>",
      desc = "Codex: Add file",
      ft = { "neo-tree", "oil" },
    },
  },
}