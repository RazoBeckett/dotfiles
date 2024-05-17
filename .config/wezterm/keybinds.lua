local M = {}

--kits are the keybinds that are used in the terminal
function M.setup(config, wezterm)
	config.keys = {
		{ key = "f", mods = "CTRL", action = wezterm.action.ToggleFullScreen },
		{ key = "r", mods = "CTRL|SHIFT", action = wezterm.action.ReloadConfiguration },
	}

	config.mouse_bindings = {
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	}

	for i = 1, 9 do
		-- switch between windows in tmux
		table.insert(config.keys, {
			key = tostring(i),
			mods = "CTRL",
			action = wezterm.action.SendString("\x02" .. tostring(i)),
		})
	end

	local keybinds_for_tmux = {
		-- key you press(with CTRL) = key tmux receives

		-- K = "\x1b\x5b\x41", -- move to pane above
		-- J = "\x1b\x5b\x42", -- move to pane below
		-- L = "\x1b\x5b\x43", -- move to pane right
		-- H = "\x1b\x5b\x44", -- move to pane above
		[";"] = ";", -- navigate over to last pane
		[","] = ",", -- renaming window
		["]"] = "]", -- open sesh menu

		R = "r", -- reload tmux config
		z = "z", -- zoom into pane
		t = "c", -- create new wndow
		T = "!", -- break pane into new window
		w = "x", -- close window
		W = "w", -- show all windows
		s = "%", -- split open pane vertically
		S = '"', -- split open pane horizontally
		D = "d", -- detach tmux session
	}

	for key, bind in pairs(keybinds_for_tmux) do
		table.insert(config.keys, {
			key = tostring(key),
			mods = "CTRL",
			action = wezterm.action.SendString("\x02" .. bind),
		})
	end
end

return M
