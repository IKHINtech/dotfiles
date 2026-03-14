return {
  {
    "github/copilot.vim",
  },
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      "github/copilot.vim",
      "nvim-lua/plenary.nvim",
    },
    build = "make tiktoken",
    opts = {
      -- model = "gpt-4o-mini",
    },
    config = function(_, opts)
      require("CopilotChat").setup(opts)

      vim.keymap.set("n", "<leader>ac", "<cmd>CopilotChatCommit<CR>", {
        desc = "Copilot generate commit message",
      })
    end,
  },
}