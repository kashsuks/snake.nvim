local M = {}

M.run = function()
  vim.cmd('split | terminal')
  vim.fn.chansend(vim.b.terminal_job_id, "./bin/snake-game\n")
end

vim.api.nvim_create_user_command('Snake', M.run, {})

return M
