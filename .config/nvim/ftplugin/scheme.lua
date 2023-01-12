local function map(m, k, v)
    vim.keymap.set(m, k, v, { silent = true })
end

map('n', '<leader>cr', '<cmd>FloatermKill rkt_shell<CR><cmd>FloatermNew --position=right --height=50 --width=80 --name=rkt_shell racket -f % -i<CR>')
