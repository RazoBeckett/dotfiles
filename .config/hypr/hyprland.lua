-- Hyprland Lua config converted from hyprland.conf.
-- Original .conf files are kept side by side.

-- Monitor configuration
hl.monitor({ output = "eDP-1", mode = "1920x1080@144", position = "0x0", scale = 1 })

-- Default applications
_G.terminal = "alacritty"
_G.fileManager = "nautilus"
_G.browser = "zen-browser"
_G.menu = "rofi -show drun -matching fuzzy"

require("modules.env")

-- core daemons
hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm app -- waybar")
	hl.exec_cmd("uwsm app -- hyprpaper")
	hl.exec_cmd("uwsm app -- hypridle")
	hl.exec_cmd("uwsm app -- nm-applet")
	hl.exec_cmd("uwsm app -- /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
	hl.exec_cmd("systemctl --user start swaync")
	hl.exec_cmd("uwsm app -- wl-paste --watch cliphist store")
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

	-- Cursor config
	hl.exec_cmd('hyprctl setcursor "Banana-Catppuccin-Mocha" 40')

	-- Auto-launch applications
	hl.exec_cmd(terminal)
	hl.exec_cmd(browser)
end)

hl.exec_cmd('gsettings set org.gnome.desktop.interface cursor-theme "Banana-Catppuccin-Mocha"')
hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 40")

hl.config({
	input = {
		repeat_rate = 34,
		repeat_delay = 150,
		kb_layout = "us",
		kb_options = "ctrl:nocaps, ALT_R:backspace",
		follow_mouse = 1,
		accel_profile = "flat",
		sensitivity = 0.2,
		numlock_by_default = true,
		touchpad = {
			natural_scroll = true,
			tap_button_map = "lmr",
			scroll_factor = 0.4,
		},
	},
	cursor = {
		no_hardware_cursors = true,
	},
	general = {
		gaps_in = 2,
		gaps_out = 4,
		border_size = 2,
		col = {
			active_border = "rgba(42424EEE)",
			inactive_border = "rgba(342D31AA)",
		},
		layout = "scrolling",
		resize_on_border = true,
	},
	xwayland = {
		force_zero_scaling = true,
	},
	decoration = {
		rounding = 0,
		shadow = { enabled = false },
		blur = {
			enabled = true,
			size = 4,
			passes = 3,
		},
	},
	animations = {
		enabled = true,
	},
	dwindle = {
		preserve_split = true,
	},
	master = {
		new_status = "salve",
	},
	ecosystem = {
		no_update_news = true,
	},
	misc = {
		-- vfr = false,
		vrr = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		force_default_wallpaper = -1,
	},
	debug = {
		disable_logs = false,
	},
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = false, speed = 0, bezier = "ease" })

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
-- The old hyprlang config used custom dispatcher/scale gestures here.
-- This Hyprland Lua build rejects those old comma-form action strings, so
-- only the supported workspace gesture is enabled for now.

require("modules.windowrule")
require("modules.keybinds")
