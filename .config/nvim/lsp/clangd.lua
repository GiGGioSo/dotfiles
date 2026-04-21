return {
    cmd = { 
        "clangd", 
        "--background-index",
        "--clang-tidy",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    root_markers = { ".git", "compile_commands.json", "compile_flags.txt" },
    
    -- Metodo universale per disabilitare il syntax highlighting LSP
    on_init = function(client)
        client.server_capabilities.semanticTokensProvider = nil
    end,

    settings = {
        clangd = {
            InlayHints = {
                Enabled = false,
            },
        },
    },
}
