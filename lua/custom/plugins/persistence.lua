return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    },
    -- load the session for the current directory
    vim.keymap.set('n', '<leader>qs', function()
      require('persistence').load()
    end),

    -- select a session to load
    vim.keymap.set('n', '<leader>qS', function()
      require('persistence').select()
    end),

    -- load the last session
    vim.keymap.set('n', '<leader>ql', function()
      require('persistence').load { last = true }
    end),

    -- stop Persistence => session won't be saved on exit
    vim.keymap.set('n', '<leader>qd', function()
      require('persistence').stop()
    end),

    -- Ensure Neotree is closed before saving the session
    vim.api.nvim_create_autocmd('User', {
      pattern = 'PersistenceSavePre',
      callback = function()
        -- Save the current tab to restore later
        local current_tab = vim.api.nvim_get_current_tabpage()

        -- Iterate through all tab pages
        for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
          -- Switch to the current tab
          vim.api.nvim_set_current_tabpage(tab)

          -- Close Neotree in this tab
          vim.cmd 'Neotree close'
        end

        -- Restore the original tab
        vim.api.nvim_set_current_tabpage(current_tab)
      end,
    }),
  },
}
