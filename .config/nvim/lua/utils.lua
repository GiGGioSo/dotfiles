Utils = {}

Utils.search_in_zeal = function(language)
    local query = ""
    local mode = vim.fn.mode()

    if mode == "v" or mode == "V" or mode == " " then
        -- 1. Recupera il testo selezionato in Visual Mode
        -- 'gv' ri-seleziona l'ultima area visuale, 'y' copia nel registro anonimo
        -- Usiamo il registro "z per non sporcare quello principale
        vim.cmd([[noautocmd silent normal! "zy]])
        query = vim.fn.getreg("z")
    else
        -- 2. Altrimenti prende la parola sotto il cursore
        query = vim.fn.expand("<cword>")
    end

    -- Pulizia della query (rimuove spazi bianchi extra)
    query = query:gsub("^%s*(.-)%s*$", "%1")

    if query == "" then
        print("Nothing to search")
        return
    end

    local zeal_bin = vim.fn.exepath("zeal")
    if zeal_bin == "" then
        print("Error: Zeal not found in PATH")
        return
    end

    -- Costruisce l'argomento docset:query
    local full_query = language .. ":" .. query

    vim.fn.jobstart({ zeal_bin, "--query", full_query }, {
        detach = true,
        on_exit = function(_, exit_code)
            if exit_code == 0 then
                print("Zeal: searching '" .. query .. "' in " .. language)
            end
        end
    })
end

Utils.toggle_colorcolumn = function()
    if vim.api.nvim_win_get_option(0, "colorcolumn") == "80" then
        vim.api.nvim_win_set_option(0, "colorcolumn", "")
    else
        vim.api.nvim_win_set_option(0, "colorcolumn", "80")
    end
    vim.cmd("redraw")
end

return Utils
