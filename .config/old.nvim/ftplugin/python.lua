local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true })
end

map('n', '<leader>cr', '<cmd>FloatermKill python_shell<CR><cmd>FloatermNew --position=right --height=50 --width=80 --name=python_shell python<CR>')
