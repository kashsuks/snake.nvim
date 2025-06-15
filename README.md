# 🐍 snake.nvim

A minimal Snake game inside Neovim, written in pure Lua. Move the snake with `hjkl`, eat apples 🍎, and avoid crashing.

## 📦 Installation (Lazy.nvim)

```lua
{
  "kashsuks/snake.nvim",
  lazy = false, -- set to true if you want it to lazy-load
  cmd = "Snake",
  config = function()
    require("snake")
  end
}
