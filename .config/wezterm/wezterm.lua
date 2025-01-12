local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "uwunicorn"
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.font = wezterm.font_with_fallback({
	{ family = "JetBrains Mono" },
	-- { family = "Comic Code" },
	-- { family = "Noto Color Emoji" },
	{ family = "Symbols Nerd Font" },
})

config.max_fps = 144
config.animation_fps = 144
config.font_size = 12.0
config.cursor_blink_rate = 0
config.enable_tab_bar = false
config.use_fancy_tab_bar = false
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.7
config.window_close_confirmation = "NeverPrompt"
config.macos_window_background_blur = 30
config.scrollback_lines = 30000
config.term = "xterm-kitty"
config.enable_wayland = false

config.window_padding = {
	top = "0.5cell",
	bottom = "0.5cell",
	left = "1.5cell",
	right = "1.5cell",
}

require("keybinds").setup(config, wezterm)
return config
