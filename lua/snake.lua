local M = {}

local state = {
  snake = {{5,5}},
  dir = {0, 1},
  food = {math.random(1, 10), math.random(1, 30)},
  width = 30,
  height = 10,
  buf = nil,
  timer = nil,
  game_over = false
}

local function draw()
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, {})
  for i = 1, state.height do
    local line = {}
    for j = 1, state.width do
      local is_body = false
      for _, s in ipairs(state.snake) do
        if s[1] == i and s[2] == j then
          is_body = true
          break
        end
      end
      if state.food[1] == i and state.food[2] == j then
        table.insert(line, "🍎")
      elseif is_body then
        table.insert(line, "⬛")
      else
        table.insert(line, "  ")
      end
    end
    vim.api.nvim_buf_set_lines(state.buf, i-1, i, false, {table.concat(line)})
  end
end

local function move()
  if state.game_over then return end

  local head = state.snake[#state.snake]
  local new_head = {head[1] + state.dir[1], head[2] + state.dir[2]}

  if new_head[1] < 1 or new_head[1] > state.height or
     new_head[2] < 1 or new_head[2] > state.width then
    state.game_over = true
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, {"Game Over!"})
    return
  end

  for _, s in ipairs(state.snake) do
    if s[1] == new_head[1] and s[2] == new_head[2] then
      state.game_over = true
      vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, {"Game Over!"})
      return
    end
  end

  table.insert(state.snake, new_head)

  if new_head[1] == state.food[1] and new_head[2] == state.food[2] then
    state.food = {math.random(1, state.height), math.random(1, state.width)}
  else
    table.remove(state.snake, 1)
  end

  draw()
end

local function set_keys()
  vim.keymap.set('n', 'h', function() state.dir = {0, -1} end, {buffer = state.buf})
  vim.keymap.set('n', 'l', function() state.dir = {0, 1} end, {buffer = state.buf})
  vim.keymap.set('n', 'k', function() state.dir = {-1, 0} end, {buffer = state.buf})
  vim.keymap.set('n', 'j', function() state.dir = {1, 0} end, {buffer = state.buf})
  vim.keymap.set('n', 'q', function()
    if state.timer then state.timer:stop() end
    vim.api.nvim_buf_delete(state.buf, {force=true})
  end, {buffer = state.buf})
end

function M.start()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
  state.buf = buf

  set_keys()
  draw()

  state.timer = vim.loop.new_timer()
  state.timer:start(0, 200, vim.schedule_wrap(move))
end

vim.api.nvim_create_user_command("Snake", M.start, {})

return M

