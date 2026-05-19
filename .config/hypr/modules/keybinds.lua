-- Converted from modules/keybinds.conf

local MODKEY = "SUPER"
local ALTKEY = "ALT"
local function sh(cmd)
	return hl.dsp.exec_cmd(cmd)
end
local function dispatch(cmd)
	return hl.dsp.exec_cmd("hyprctl dispatch " .. cmd)
end

-- fn buttons
hl.bind("XF86AudioLowerVolume", sh("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioRaiseVolume", sh("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioMute", sh("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
hl.bind("XF86AudioMicMute", sh("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"))
hl.bind("XF86MonBrightnessUp", sh("brightnessctl s 10%+"), { repeating = true })
hl.bind("XF86MonBrightnessDown", sh("brightnessctl s 10%-"), { repeating = true })

-- External keyboard
hl.bind(MODKEY .. " + 0", sh("brightnessctl s 10%+"), { repeating = true })
hl.bind(MODKEY .. " + 9", sh("brightnessctl s 10%-"), { repeating = true })

-- Applications
hl.bind(MODKEY .. " + RETURN", sh(terminal))
hl.bind(MODKEY .. " + P", sh("fuzzel"))
hl.bind(ALTKEY .. " + space", sh("vicinae toggle"))
hl.bind(MODKEY .. " + O", sh("obsidian"))
hl.bind(MODKEY .. " + E", function()
	hl.dispatch(hl.dsp.focus({ workspace = 3 }))

	local nautilus_open = #hl.get_windows({ class = "^(org.gnome.Nautilus)$" }) > 0
	if not nautilus_open then
		hl.exec_cmd(fileManager)
	end
end)

hl.bind(MODKEY .. " + F", hl.dsp.window.fullscreen_state({ internal = 2, client = 0, action = "toggle" }))
hl.bind(MODKEY .. " + SHIFT + F", hl.dsp.window.fullscreen_state({ internal = 1, client = 0, action = "toggle" }))
hl.bind(ALTKEY .. " + Q", hl.dsp.window.kill())
hl.bind(MODKEY .. " + " .. ALTKEY .. " + V", hl.dsp.window.float({ action = "toggle" }))

-- move focus between windows
hl.bind(ALTKEY .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(ALTKEY .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(ALTKEY .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(ALTKEY .. " + J", hl.dsp.focus({ direction = "down" }))

-- swap windows
hl.bind("SHIFT + " .. ALTKEY .. " + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind("SHIFT + " .. ALTKEY .. " + L", hl.dsp.window.swap({ direction = "right" }))
hl.bind("SHIFT + " .. ALTKEY .. " + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind("SHIFT + " .. ALTKEY .. " + J", hl.dsp.window.swap({ direction = "down" }))

for i = 1, 10 do
	local key = i % 10
	hl.bind(ALTKEY .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind("SHIFT + " .. ALTKEY .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- scratchpad
hl.bind(MODKEY .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind("SHIFT + " .. ALTKEY .. " + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Navigate between workspaces using scroll wheel
hl.bind(MODKEY .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(MODKEY .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- move windows using mouse
hl.bind(MODKEY .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(MODKEY .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Notification Center
hl.bind(MODKEY .. " + N", sh("swaync-client -t"))
hl.bind(MODKEY .. " + SHIFT + N", sh("swaync-client -R && swaync-client -rs"))

-- Lock screen
hl.bind(MODKEY .. " + L", sh("hyprlock"))

-- screenshot
hl.bind(MODKEY .. " + SHIFT + S", sh("flameshot gui"))

-- hibernate
hl.bind(MODKEY .. " + SHIFT + H", sh("hyprlock & sleep 1 && systemctl hibernate"))

-- clipboard
hl.bind(ALTKEY .. " + W", sh("vicinae vicinae://launch/wm/switch-windows"))
hl.bind(MODKEY .. " + V", sh("vicinae vicinae://launch/clipboard/history"))
hl.bind(MODKEY .. " + period", sh("vicinae vicinae://launch/core/search-emojis"))

-- Grouping
hl.bind(MODKEY .. " + G", hl.dsp.group.toggle())

-- color picker
hl.bind(MODKEY .. " + C", sh('hyprpicker -aq && notify-send -h int:transient:1 "Color copied!" "Hex: $(wl-paste)"'))

-- Restart Waybar
hl.bind(MODKEY .. " + B", sh("pkill -SIGUSR2 waybar"))

-- Tricks
hl.bind(MODKEY .. " + Q", sh('qrencode -o - "$(wl-paste)" | display'))
hl.bind(
	MODKEY .. " + I",
	sh('curl -sS ipinfo.io/ip | wl-copy && notify-send -h int:transient:1 "IP LEAKED: $(wl-paste)"')
)
hl.bind(
	MODKEY .. " + SHIFT + B",
	sh(
		'((bluetoothctl disconnect && bluetoothctl pair 90:A0:BE:A5:FF:7D || bluetoothctl connect 90:A0:BE:A5:FF:7D) && notify-send -i network-bluetooth -h int:transient:1 "Bluetooh" "Connected To Airdopes 800")'
	)
)
hl.bind(MODKEY .. " + T", sh("alacritty --class todo-popup -e nvim $todofile"))
hl.bind(MODKEY .. " + H", sh("voxtype record toggle"))
hl.bind(MODKEY .. " + A", sh([[bash -c 'notify-send "$(wl-paste -p --primary)"']]))

-- Window management
hl.bind("SUPER + W", sh("qs -p ~/.config/quickshell ipc call overview toggle"))
