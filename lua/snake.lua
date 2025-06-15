local M = {}

local state = {
  snake = {{5,5}},
  dir = {0, 1},
  food = {math.random(1, 10), math.random(1, 30)},
  width = 30,
  height = 10,
  buf = nil,
  timer = nil,
  gameOver = false,
  score = 0
}

local function draw()
  vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, {})

  local top = "╔" .. string.rep("═", state.width * 2) .. "╗"
  vim.api.nvim_buf_set_lines(state.buf, 0, 1, false, {top})

  for i = 1, state.height do
    local line = {}
    table.insert(line, "║")
    for j = 1, state.width do
      local isBody = false
      for _, s in ipairs(state.snake) do
        if s[1] == i and s[2] == j then
          isBody = true
          break
        end
      end
      if state.food[1] == i and state.food[2] == j then
        table.insert(line, "🍎")
      elseif isBody then
        table.insert(line, "⬛")
      else
        table.insert(line, "  ")
      end
    end
    table.insert(line, "║")
    vim.api.nvim_buf_set_lines(state.buf, i, i + 1, false, {table.concat(line)})
  end

  local bottom = "╚" .. string.rep("═", state.width * 2) .. "╝  Score: " .. state.score
  vim.api.nvim_buf_set_lines(state.buf, state.height + 1, state.height + 2, false, {bottom})
end

local function move()
  if state.gameOver then return end

  local head = state.snake[#state.snake]
  local newHead = {head[1] + state.dir[1], head[2] + state.dir[2]}

  if newHead[1] < 1 or newHead[1] > state.height or
     newHead[2] < 1 or newHead[2] > state.width then
    state.gameOver = true
    vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, {"Game Over! Final Score: " .. state.score})
    return
  end

  for _, s in ipairs(state.snake) do
    if s[1] == newHead[1] and s[2] == newHead[2] then
      state.gameOver = true
      vim.api.nvim_buf_set_lines(state.buf, 0, -1, false, {"Game Over! Final Score: " .. state.score})
      return
    end
  end

  table.insert(state.snake, newHead)

  if newHead[1] == state.food[1] and newHead[2] == state.food[2] then
    state.food = {math.random(1, state.height), math.random(1, state.width)}
    state.score = state.score + 1
  else
    table.remove(state.snake, 1)
  end

  draw()
end

local function setKeys()
  vim.keymap.set('n', 'a', function() state.dir = {0, -1} end, {buffer = state.buf})
  vim.keymap.set('n', 'd', function() state.dir = {0, 1} end, {buffer = state.buf})
  vim.keymap.set('n', 'w', function() state.dir = {-1, 0} end, {buffer = state.buf})
  vim.keymap.set('n', 's', function() state.dir = {1, 0} end, {buffer = state.buf})
  vim.keymap.set('n', 'q', function()
    if state.timer then state.timer:stop() end
    vim.api.nvim_buf_delete(state.buf, {force=true})
  end, {buffer = state.buf})
end

function M.start()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_current_buf(buf)
  state.buf = buf
  state.snake = {{5,5}}
  state.dir = {0, 1}
  state.food = {math.random(1, state.height), math.random(1, state.width)}
  state.score = 0
  state.gameOver = false

  setKeys()
  draw()

  state.timer = vim.loop.new_timer()
  state.timer:start(0, 200, vim.schedule_wrap(move))
end

vim.api.nvim_create_user_command("Snake", M.start, {})

return M
