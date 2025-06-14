# snake.nvim

A snake game you can run inside Neovim! Written in C++.

## Install

Using lazy.nvim:

```lua
{
  "yourname/snake.nvim",
  config = function()
    vim.api.nvim_set_keymap("n", "<leader>sg", ":Snake<CR>", { noremap = true, silent = true })
  end,
}
