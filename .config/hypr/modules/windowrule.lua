-- Converted from modules/windowrule.conf

local function wr(spec)
	hl.window_rule(spec)
end
local function lr(spec)
	hl.layer_rule(spec)
end

wr({ name = "suppress-maximize-events", match = { class = ".*" }, suppress_event = "maximize" })

-- idle inhibit rules
wr({
	name = "idle-celluloid-mpv-vlc",
	match = { class = "^(.*celluloid.*)$|^(.*mpv.*)$|^(.*vlc.*)$" },
	idle_inhibit = "fullscreen",
})
wr({ name = "idle-spotify", match = { class = "^(.*[Ss]potify.*)$" }, idle_inhibit = "fullscreen" })
wr({
	name = "idle-browsers",
	match = {
		class = [[^(.*LibreWolf.*)$|^(.*floorp.*)$|^(.*Brave.*)$|^(.*[Ff]irefox.*)$|^(.*chromium.*)$|^(.*vivaldi.*)$|^(.*zen(-browser)?\b.*)$]],
	},
	idle_inhibit = "fullscreen",
})

-- common modals
for _, title in ipairs({
	"^(Open)$",
	"^(Authentication Required)$",
	"^(Add Folder to Workspace)$",
	"^(Choose Files)$",
	"^(Save As)$",
	"^(Confirm to replace files)$",
	"^(File Operation Progress)$",
	"^(File Upload)(.*)$",
	"^(Choose wallpaper)(.*)$",
	"^(Library)(.*)$",
	"^(.*dialog.*)$",
}) do
	wr({ match = { title = title }, float = true })
end

for _, class in ipairs({
	"^([Xx]dg-desktop-portal-gtk)$",
	"^(.*dialog.*)$",
	"^(org.gnome.Calculator)$",
}) do
	wr({ match = { class = class }, float = true })
end

-- Window rules for the todo popup
wr({ match = { class = "^(todo-popup)$" }, float = true })
wr({ match = { class = "^(todo-popup)$" }, center = true })
wr({ match = { class = "^(todo-popup)$" }, size = "800 600" })
wr({ match = { class = "^(todo-popup)$" }, opacity = "0.95 override" })

-- Float and center file pickers
wr({ match = { class = "xdg-desktop-portal-gtk", title = "^(Open.*Files?|Save.*Files?|All Files|Save)" }, float = true })
wr({
	match = { class = "xdg-desktop-portal-gtk", title = "^(Open.*Files?|Save.*Files?|All Files|Save)" },
	center = true,
})

-- Fix some dragging issues with XWayland
wr({
	name = "fix-xwayland-drags",
	match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
	no_focus = true,
})

-- specific to workspace
local workspace_rules = {
	{ "2 silent", "^(zen)$" },
	{ "2 silent", "^(brave-browser)$" },
	{ "2 silent", "^(thorium-browser)$" },
	{ "2 silent", "^(google-chrome)$" },
	{ "3 silent", "^(nemo)$" },
	{ "3 silent", "^(org.gnome.Nautilus)$" },
	{ "4 silent", "^(signal)$" },
	{ "4 silent", [[^(chrome-web\.whatsapp\.com__-Default)$]] },
	{ "5 silent", "^(bruno)$" },
	{ "8 silent", [[^(chrome-open\.spotify\.com__-Default)$]] },
	{ "9 silent", "^(obsidian)$" },
}
for _, rule in ipairs(workspace_rules) do
	wr({ match = { class = rule[2] }, workspace = rule[1] })
end

-- QuickShell
wr({ match = { title = "^(qs-master)$" }, float = true })
wr({ match = { title = "^(qs-master)$" }, pin = true })
wr({ match = { title = "^(qs-master)$" }, no_shadow = true })
wr({ match = { title = "^(qs-master)$" }, border_size = 0 })
wr({ match = { title = "^(qs-master)$" }, no_initial_focus = true })
wr({ match = { title = "^(qs-master)$" }, move = "-5000 -5000" })

-- Layer rules
lr({ match = { namespace = "rofi" }, blur = true })
lr({ match = { namespace = "wofi" }, blur = true })
lr({ match = { namespace = "rofi" }, ignore_alpha = 0 })
lr({ match = { namespace = "wofi" }, ignore_alpha = 0 })
lr({ match = { namespace = "notifications" }, blur = true })
lr({ match = { namespace = "notifications" }, ignore_alpha = 0 })
lr({ match = { namespace = "swaync-notification-window" }, blur = true })
lr({ match = { namespace = "swaync-notification-window" }, ignore_alpha = 0.1 })
lr({ match = { namespace = "swaync-control-center" }, blur = true })
lr({ match = { namespace = "swaync-control-center" }, ignore_alpha = 0.1 })
lr({ match = { namespace = "logout_dialog" }, blur = true })
lr({ match = { namespace = "vicinae" }, blur = true, ignore_alpha = 0 })
lr({ match = { namespace = "vicinae" }, no_anim = true })
