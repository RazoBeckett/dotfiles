local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Macchiato"
config.font = wezterm.font_with_fallback({
	{ family = "BlexMono Nerd Font" },
	{ family = "Symbols Nerd Font" },
	{ family = "Noto Color Emoji" },
})

config.font_size = 12.4
config.cursor_blink_rate = 0
config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.7
config.macos_window_background_blur = 30
config.status_update_interval = 1000
config.scrollback_lines = 30000
config.term = "xterm-256color"

config.window_padding = {
	top = "0.5cell",
	bottom = "0.5cell",
	left = "1.5cell",
	right = "1.5cell",
}

require("keybinds").setup(config, wezterm)
return config
