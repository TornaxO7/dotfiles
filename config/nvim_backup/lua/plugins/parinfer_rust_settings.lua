return {
    "eraserhd/parinfer-rust",
    lazy = false,
    enabled = false,
    dependencies = { "elkowar/yuck.vim" },
    build = function() os.execute("cargo build --release") end,
}
