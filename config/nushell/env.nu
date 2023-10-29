# Nushell Environment Config File
#
# version = 0.80.0

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
let-env ENV_CONVERSIONS = {
  "PATH": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
  "Path": {
    from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
    to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
  }
}

# Directories to search for scripts when calling source or use
#
# By default, <nushell-config-dir>/scripts is added
let-env NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts')
]

# Directories to search for plugin binaries when calling register
#
# By default, <nushell-config-dir>/plugins is added
let-env NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins')
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# let-env PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
$env.VISUAL = "nvim"
$env.SUDO_EDITOR = "nvim"
$env.MANPAGER = "nvim +Man!"
$env.PATH = $env.PATH | append ($env.HOME | path join .local/bin)
$env.NIX_PATH = $env.NIX_PATH 
  | append ($env.HOME | path join ./nix-defexpr/channels)
  | append ($env.HOME | path join dotfiles/shells)
$env.MOZ_USE_XINPUT2 = "1";

$env.STARSHIP_SHELL = "nu"
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

zoxide init nushell | save -f ~/.zoxide.nu
