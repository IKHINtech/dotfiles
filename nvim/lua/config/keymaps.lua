-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- keluar dari terminal mode dengan ESC
vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- helper: buka terminal di window aktif
local function open_term_here()
  vim.cmd("terminal")
end

-- layout:
-- editor
-- ---------------------
-- term1 | term2 | term3
local function open_3_terminal_layout()
  -- kalau sekarang sedang di terminal mode, keluar dulu
  vim.cmd("stopinsert")

  -- simpan window editor aktif
  local editor_win = vim.api.nvim_get_current_win()

  -- buat split horizontal di bawah
  vim.cmd("belowright split")
  vim.cmd("resize 15")

  -- terminal 1
  open_term_here()

  -- pindah ke normal mode agar bisa split
  vim.cmd("stopinsert")

  -- terminal 2 (split vertical dari area terminal bawah)
  vim.cmd("vsplit")
  open_term_here()
  vim.cmd("stopinsert")

  -- terminal 3
  vim.cmd("vsplit")
  open_term_here()
  vim.cmd("stopinsert")

  -- samakan lebar semua terminal
  vim.cmd("wincmd =")

  -- kembali ke editor
  vim.api.nvim_set_current_win(editor_win)
end

-- hapus semua terminal split di bawah lalu buat ulang layout
local function reset_3_terminal_layout()
  local editor_win = vim.api.nvim_get_current_win()

  -- tutup semua window selain editor saat ini
  vim.cmd("only")

  -- buat layout baru
  open_3_terminal_layout()

  -- kembali ke editor
  vim.api.nvim_set_current_win(editor_win)
end

-- shortcut utama
vim.keymap.set("n", "<leader>tt", open_3_terminal_layout, {
  desc = "Open 3 terminal layout",
})

-- shortcut reset layout
vim.keymap.set("n", "<leader>tT", reset_3_terminal_layout, {
  desc = "Reset 3 terminal layout",
})