Utils = {}

Utils.search_in_zeal = function(language)
    -- I use "d register for the documentation
    local PATH_TO_ZEAL = "/usr/bin/zeal"
    vim.api.nvim_feedkeys('lbve"dy', 'x', true)
    local yanked = vim.fn.getreg('"d')
    vim.fn.jobstart(PATH_TO_ZEAL .. " " .. language .. ":" .. yanked)
    print("Searching '" .. yanked .. "' into Zeal...")
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
