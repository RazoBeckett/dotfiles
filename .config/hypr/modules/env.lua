-- Converted from modules/env.conf

local env = {
	{ "XCURSOR_SIZE", "40" },
	{ "WLR_NO_HARDWARE_CURSORS", "0" },
	{ "XDG_CONFIG_HOME", "$HOME/.config" },
	{ "XDG_CACHE_HOME", "$HOME/.cache" },
	{ "ERRFILE", "$XDG_CACHE_HOME/X11/xsession-errors" },
	{ "XDG_DATA_HOME", "$HOME/.local/share" },
	{ "XDG_STATE_HOME", "$HOME/.local/state" },
	{ "XDG_DATA_DIRS", "/usr/local/share/:/usr/share" },
	{ "CARGO_HOME", "$XDG_DATA_HOME/cargo" },
	{ "ELECTRON_OZONE_PLATFORM_HINT", "auto" },
	{ "QT_QPA_PLATFORM", "wayland" },
	{ "QT_STYLE_OVERRIDE", "kvantum" },
	{ "GDK_BACKEND", "wayland" },
	{ "SDL_VIDEODRIVER", "wayland" },
	{ "MOZ_ENABLE_WAYLAND", "1" },
	{ "ELECTRON_OZONE_PLATFORM_HINT", "wayland" },
	{ "OZONE_PLATFORM", "wayland" },
	{ "XCOMPOSEFILE", "~/.XCompose" },
	{ "EDITOR", "nvim" },
}

local resolved = {}

local function lookup(name)
	-- Prefer values already set by this file, then fall back to the process env.
	return resolved[name] or os.getenv(name) or ""
end

local function expand(value)
	-- Expand leading ~/ first.
	value = value:gsub("^~", lookup("HOME"))

	-- Expand ${VAR} and $VAR. Repeat a few times so values can reference
	-- variables defined earlier in this same file, e.g. ERRFILE -> XDG_CACHE_HOME.
	for _ = 1, 5 do
		local before = value
		value = value:gsub("%${([%w_]+)}", lookup)
		value = value:gsub("%$([%w_]+)", lookup)
		if value == before then
			break
		end
	end

	return value
end

for _, item in ipairs(env) do
	local key = item[1]
	local value = expand(item[2])
	resolved[key] = value
	hl.env(key, value)
end
