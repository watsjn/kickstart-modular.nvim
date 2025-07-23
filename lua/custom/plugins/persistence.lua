return {
  {
    'folke/persistence.nvim',
    event = 'BufReadPre', -- this will only start session saving when an actual file was opened
    opts = {
      -- add any custom options here
    },
    -- load the session for the current directory
    vim.keymap.set('n', '<leader>pd', function()
      require('persistence').load()
    end, { desc = 'Load the session for the current [D]irectory' }),

    -- select a session to load
    vim.keymap.set('n', '<leader>ps', function()
      require('persistence').select()
    end, { desc = '[S]elect a session to load' }),

    -- load the last session
    vim.keymap.set('n', '<leader>pl', function()
      require('persistence').load { last = true }
    end, { desc = 'Load the [L]ast session' }),

    -- stop Persistence => session won't be saved on exit
    vim.keymap.set('n', '<leader>pc', function()
      require('persistence').stop()
    end, { desc = '[C]ancel session save on exit' }),

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
