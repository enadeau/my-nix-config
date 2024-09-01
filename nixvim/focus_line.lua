function PulseCurrentLine()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1  -- Get current line (0-indexed)
  local ns_id = vim.api.nvim_create_namespace('PulseHighlight')  -- Create a new highlight namespace

  -- Add highlight to the current line
  vim.api.nvim_buf_add_highlight(bufnr, ns_id, 'Visual', cursor_line, 0, -1)

  -- Remove the highlight after a delay (300ms)
  vim.defer_fn(function()
    vim.api.nvim_buf_clear_namespace(bufnr, ns_id, cursor_line, cursor_line + 1)
  end, 300)
end

function FocusCurrentLine()
  -- Step 1: Set a mark 'z' at the current cursor position
  vim.cmd('normal! mz')

  -- Step 2: Close all folds
  vim.cmd('normal! zM')

  -- Step 3: Open the fold(s) containing the current line and center it on the screen
  vim.cmd('normal! zvzz')

  -- Step 4: Scroll down by 10 lines
   vim.cmd('exe "normal! 10\\<C-e>"')

  -- Step 5: Jump back to the original position
  vim.cmd('normal! `z')

  -- Step 6: Run the Pulse command
  PulseCurrentLine()
end

-- Map the function to a key, for example F3
-- vim.api.nvim_set_keymap('n', '<F3>', ':lua PulseCurrentLine()<CR>', { noremap = true, silent = true })

-- Map the function to a key, for example <Leader>f
-- vim.api.nvim_set_keymap('n', '<F4>', ':lua FocusAndPulseCurrentLine()<CR>', { noremap = true, silent = true })

