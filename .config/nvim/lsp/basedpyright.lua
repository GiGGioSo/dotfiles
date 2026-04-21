local uv = vim.uv

local function is_file(path)
    local stat = uv.fs_stat(path)
    return stat and stat.type == "file"
end

local function find_venv(root_dir)
    local search_dir = root_dir
    local venv_names = { ".venv", "venv", "env" }
    local python_relpath = vim.fn.has("win32") == 1
        and { "Scripts", "python.exe" }
        or { "bin", "python" }

    for _ = 0, 2 do
        if not search_dir then
            break
        end

        for _, venv_name in ipairs(venv_names) do
            local venv_dir = vim.fs.joinpath(search_dir, venv_name)
            local python_path = vim.fs.joinpath(venv_dir, unpack(python_relpath))

            if is_file(python_path) then
                return {
                    python_path = python_path,
                    venv = venv_name,
                    venv_path = search_dir,
                }
            end
        end

        local parent = vim.fs.dirname(search_dir)
        if not parent or parent == search_dir then
            break
        end
        search_dir = parent
    end
end

return {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "pyrightconfig.json",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        ".git",
    },

    before_init = function(_, config)
        local venv = find_venv(config.root_dir or vim.fn.getcwd())
        if not venv then
            return
        end

        config.settings = config.settings or {}
        config.settings.python = vim.tbl_deep_extend("force", config.settings.python or {}, {
            pythonPath = venv.python_path,
            venv = venv.venv,
            venvPath = venv.venv_path,
        })
    end,

    -- Metodo universale per disabilitare il syntax highlighting LSP
    on_init = function(client)
        client.server_capabilities.semanticTokensProvider = nil
    end,

    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "standard",
            },
        },
    },
}
