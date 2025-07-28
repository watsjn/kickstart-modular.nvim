-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- vim.keymap.set("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- vim.keymap.set("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- vim.keymap.set("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- vim.keymap.set("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- vim: ts=2 sts=2 sw=2 et

-- terminal window open @TODO: to move outside comamnds config
--
-- vim.keymap.set('n', '<space>tt', function()
--   vim.cmd.vnew()
--   vim.cmd.term()
--   vim.cmd.wincmd 'J'
--   vim.api.nvim_win_set_height(0, 25)
-- end, { desc = 'Open terminal window' })

vim.api.nvim_create_user_command('TermToggle', function()
  local is_open = vim.g.term_win_id ~= nil and vim.api.nvim_win_is_valid(vim.g.term_win_id)

  if is_open then
    vim.api.nvim_win_hide(vim.g.term_win_id)
    vim.g.term_win_id = nil
    return
  end

  -- Open new window 25 lines tall at the bottom of the screen
  vim.cmd 'botright 25 new'
  vim.g.term_win_id = vim.api.nvim_get_current_win()

  local has_term_buf = vim.g.term_buf_id ~= nil and vim.api.nvim_buf_is_valid(vim.g.term_buf_id)

  if has_term_buf then
    vim.api.nvim_win_set_buf(vim.g.term_win_id, vim.g.term_buf_id)
  else
    vim.cmd.term()
    vim.g.term_buf_id = vim.api.nvim_get_current_buf()
  end

  -- vim.cmd.startinsert()
end, {})

-- For session manager usage
vim.api.nvim_create_user_command('TermKill', function()
  if vim.g.term_win_id ~= nil then
    vim.api.nvim_win_close(vim.g.term_win_id, true)
    vim.g.term_win_id = nil
  end
  if vim.g.term_buf_id ~= nil then
    vim.api.nvim_buf_delete(vim.g.term_buf_id, { force = true })
    vim.g.term_buf_id = nil
  end
end, {})

vim.keymap.set('n', '<leader>tt', vim.cmd.TermToggle, { desc = '[T]oggle terminal', silent = true })
