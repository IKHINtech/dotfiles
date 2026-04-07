return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    direction = "horizontal",
    size = 5,
    open_mapping = [[<c-\>]],
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    close_on_exit = false,
    shell = vim.o.shell,
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)

    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
  end,
}
