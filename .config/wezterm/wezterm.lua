local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Macchiato"
config.enable_tab_bar = false
config.font = wezterm.font_with_fallback({
	{ family = "BlexMono Nerd Font", weight = "Medium" },
})
config.font_size = 12.0
config.macos_window_background_blur = 30
config.window_background_opacity = 0.7
config.window_decorations = "RESIZE"
config.window_padding = {
	top = "0.5cell",
	bottom = "0.5cell",
	left = "1.5cell",
	right = "1.5cell",
}
config.keys = {
	{
		key = "f",
		mods = "CTRL",
		action = wezterm.action.ToggleFullScreen,
	},
}
config.cursor_blink_rate = 0
config.mouse_bindings = {
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

return config
