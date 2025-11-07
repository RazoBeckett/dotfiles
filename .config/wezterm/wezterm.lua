local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "uwunicorn"
config.line_height = 1.2
config.harfbuzz_features = { "calt=0", "clig=0", "liga=0" }
config.font = wezterm.font_with_fallback({
	-- "JetBrains Mono",
	"SF Mono",
	"Symbols Nerd Font",
})

config.max_fps = 120
config.front_end = "WebGpu"
config.webgpu_power_preference = "HighPerformance"
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
config.term = "xterm-256color"
config.enable_wayland = true

config.window_padding = {
	top = "0.5cell",
	bottom = "0.5cell",
	left = "1.5cell",
	right = "1.5cell",
}

require("keybinds").setup(config, wezterm)
return config
