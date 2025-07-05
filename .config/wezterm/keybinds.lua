local M = {}

function M.setup(config, wezterm)
	local act = wezterm.action

	config.keys = {
		{ key = "f", mods = "CTRL|SHIFT", action = act.ToggleFullScreen },
		{ key = "r", mods = "CTRL|SHIFT", action = act.ReloadConfiguration },
	}

	-- Your Ctrl+F mapping for tmux
	table.insert(config.keys, {
		key = "f",
		mods = "CTRL",
		action = act.Multiple({
			act.SendKey({ key = "b", mods = "CTRL" }),
			act.SendKey({ key = "f" }),
		}),
	})

	-- existing numeric tmux bindings...
	for i = 1, 9 do
		table.insert(config.keys, {
			key = tostring(i),
			mods = "CTRL",
			action = act.SendString("\x02" .. tostring(i)),
		})
	end

	-- custom tmux keybinds
	local keybinds_for_tmux = {
		[";"] = ";",
		[","] = ",",
		["]"] = "]",
		["["] = "[",
		["\\"] = "\\",
		R = "r",
		f = "f",
		z = "z",
		t = "c",
		T = "!",
		w = "x",
		W = "w",
		s = "%",
		S = '"',
		D = "d",
	}
	for key, bind in pairs(keybinds_for_tmux) do
		table.insert(config.keys, {
			key = key,
			mods = "CTRL",
			action = act.SendString("\x02" .. bind),
		})
	end

	-- your existing mouse_bindings here...
	config.mouse_bindings = {
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = act.OpenLinkAtMouseCursor,
		},
	}
end

return M
