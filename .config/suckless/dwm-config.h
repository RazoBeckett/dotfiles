/* See LICENSE file for copyright and license details. */
/* NOTE: make symbolic link of this file into dwm build directory */

/* appearance */
#include <unistd.h>
static const unsigned int borderpx       = 1;   /* border pixel of windows */
static const unsigned int gappx          = 8;   /* gaps between windows */
static const unsigned int fgappx         = 16;  /* gaps around only one window*/
static const unsigned int snap           = 32;  /* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft  = 0;   /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int onlyclient   = 1;        /* 1: keep border even if only client */
static const int showsystray  = 1;        /* 0 means no systray */
static const int showbar      = 1;        /* 0 means no bar */
static const int topbar       = 1;        /* 0 means bottom bar */
static const int titlestyle   = 1;        /* 0: left aligned , 1: center aligned */
static const char *fonts[]    = { "JetBrainsMono Nerd Font:weight=bold:size=11:antialias=true:autohint=true" };
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */

static const char col_bg[]             = "#141216"; // Background (Dark)
static const char col_bg_alt[]         = "#27232b"; // Background Alt (Lighter Dark)
static const char col_accent[]         = "#AC82E9"; // Primary Accent
static const char col_accent_alt[]     = "#8F56E1"; // Accent Deep
static const char col_fg[]             = "#c4e881"; // Foreground (Text)
static const char col_highlight[]      = "#d8cab8"; // Highlight / Complementary Accent

static const char *colors[][3] = {
    /*               fg             bg           border */
    [SchemeNorm]  = { col_accent,     col_bg,      col_bg_alt },
    [SchemeSel]   = { col_highlight,  col_bg,      col_accent_alt },
    [SchemeTitle] = { col_highlight,  col_bg,      col_bg },
};

static const char *const autostart[] = {
	// "bash", "-c", "while true; do sleep 1800 && notify-send 'Reminder' 'Take a quick walk'; done", NULL,
	// "bash", "-c", "while true; do sleep 2700 && notify-send 'Reminder' 'Drink some water'; done", NULL,
	//"rog-control-center", NULL, // only for asus rog laptops
	"dunst", NULL,
	"bash", "-c", "$HOME/.local/bin/launch_dwmblocks", NULL,
	// "sh", "-c", "feh --randomize --bg-fill $HOME/Pictures/nord-background/*", NULL,
	"nitrogen", "--restore", NULL,
	"xfce4-clipman", NULL,
	"nm-applet", "--indicator", NULL,
	"picom", "-b", NULL,
	"touchegg", NULL,
	"xset", "r", "rate", "210", "40", NULL,
	// "bash", "-c", "xmodmap $HOME/.config/Xmodmap", NULL,
	"bash", "-c", "xrdb -load $HOME/.config/Xresources", NULL,
	"/usr/lib/mate-polkit/polkit-mate-authentication-agent-1", NULL,
	"udiskie","-A", "-t", NULL,
	"zen-browser", NULL,
	"alacritty", NULL,
	NULL /* terminate */
};

/* tagging */
static const char *tags[] = { "", "", "", "", "", "6", "󰊱", "󰓇", "", "󰀿" };

#include "apprules.h"

/* layout(s) */
static const float mfact	  = 0.55; /* factor of master area size [0.05..0.95] */
static const int   nmaster        = 1;    /* number of clients in master area */
static const int   resizehints	  = 0;    /* 1 means respect size hints in tiled resizals */
static const int   lockfullscreen = 1;	  /* 1 will force focus on the fullscreen window */

/* Additional layouts includes: */
#include "layouts/grid.c"
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },				 /* first entry is default */
	{ "><>",      NULL },				 /* no layout function means floating behavior */
	{ "[M]",      monocle },
	//{ "|M|",      centeredmaster },
	{ "HHH",      grid },
};

/* key definitions */
#define MODKEY Mod4Mask
#define ALTKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ ALTKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ ALTKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ ALTKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ ALTKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define ICONSIZE 20					/* icon size */
#define ICONSPACING 8					/* space between icon and title */
#define SHCMD(cmd)	{ .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }
#define CMD(...)	{ .v = (const char*[]){ __VA_ARGS__, NULL } }
#define STATUSBAR "dwmblocks"

#include <X11/XF86keysym.h>
/* user constants */
#define TERMINAL "alacritty"
#define FILEMANAGER "nemo"
#define TOPMENU SHCMD("~/.local/bin/topmenu")

/* user commands */
static const char *dmenucmd[]	= { "dmenu_run", "-c", "-l", "7", "-m", dmenumon, "-fn", "JetBrains Mono Nerd Font:weight=bold:size=12:antialias=true:hinting=true", NULL }; //"-c", "-l", "7",
static const char *passmenucmd[]= { "passmenu", "-c", "-l", "3", "-fn", "JetBrains Mono Nerd Font:weight=bold:size=12:antialias=true:hinting=true", NULL };
static const char *rofisearch[]	= { "rofi", "-show", "drun", NULL };
static const char *rofiemoji[]	= { "rofi", "-modi", "emoji", "-show", "emoji", NULL };

static const Key keys[] = {

	/* FN key functionality */
	{ 0, XF86XK_AudioRaiseVolume,  spawn, SHCMD("~/.local/bin/volufication up && kill -38 $(pidof dwmblocks)") },
	{ 0, XF86XK_AudioLowerVolume,  spawn, SHCMD("~/.local/bin/volufication down && kill -38 $(pidof dwmblocks)") },
	{ 0, XF86XK_AudioMute,         spawn, SHCMD("~/.local/bin/volufication mute && kill -38 $(pidof dwmblocks)") },
	{ 0, XF86XK_AudioMicMute,      spawn, SHCMD("~/.local/bin/volufication muteMic && kill -38 $(pidof dwmblocks)") },
	/* Brightness FN */
	{ 0, XF86XK_MonBrightnessUp,   spawn, SHCMD("~/.local/bin/brightification up && kill -39 $(pidof dwmblocks)") },
	{ 0, XF86XK_MonBrightnessDown, spawn, SHCMD("~/.local/bin/brightification down && kill -39 $(pidof dwmblocks)") },
	{ MODKEY,XK_9,                 spawn, SHCMD("~/.local/bin/brightification up && kill -39 $(pidof dwmblocks)") },
	{ MODKEY,XK_8,                 spawn, SHCMD("~/.local/bin/brightification down && kill -39 $(pidof dwmblocks)") },
	/* Touchpad FN */
	{ 0, XF86XK_TouchpadToggle,    spawn, SHCMD("~/.local/bin/touchpad toggle") },

	/* modifier                 key                function        argument */
	{ MODKEY,                   XK_p,              spawn,          {.v = rofisearch } },
	{ MODKEY|ALTKEY,            XK_b,              togglebar,      {0} },
	{ ALTKEY|ShiftMask,         XK_h,              rotatestack,    {.i = +1 } },
	{ ALTKEY|ShiftMask,         XK_l,              rotatestack,    {.i = -1 } },
	{ ALTKEY,                   XK_h,              focusstack,     {.i = +1 } },
	{ ALTKEY,                   XK_l,              focusstack,     {.i = -1 } },
	{ MODKEY,                   XK_i,              incnmaster,     {.i = +1 } },
	{ MODKEY,                   XK_d,              incnmaster,     {.i = -1 } },
	{ ALTKEY,                   XK_j,              setmfact,       {.f = -0.05} },
	{ ALTKEY,                   XK_k,              setmfact,       {.f = +0.05} },
	{ ALTKEY,                   XK_Return,         zoom,           {0} },
	{ ALTKEY,                   XK_Tab,            view,           {0} },
	{ ALTKEY,                   XK_q,              killclient,     {0} },
	{ ALTKEY|ShiftMask,         XK_q,              killclient,     {.ui = 1} },  // kill unselect
	{ MODKEY|ShiftMask,         XK_q,              killclient,     {.ui = 2} },  // killall
	{ ALTKEY|ShiftMask,         XK_space,          togglefloating, {0} },
	{ MODKEY,                   XK_f,              togglefullscr,  {0} },
	{ MODKEY|ShiftMask,         XK_t,              setlayout,      {.v = &layouts[0]} },
	{ MODKEY|ShiftMask,         XK_f,              setlayout,      {.v = &layouts[1]} },
	{ MODKEY|ShiftMask,         XK_m,              setlayout,      {.v = &layouts[2]} },
	{ MODKEY|ShiftMask,         XK_c,              setlayout,      {.v = &layouts[3]} },
	{ MODKEY|ShiftMask,         XK_g,              setlayout,      {.v = &layouts[4]} },
	{ MODKEY,                   XK_0,              view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,         XK_0,              tag,            {.ui = ~0 } },
	{ MODKEY,                   XK_comma,          focusmon,       {.i = -1 } },
	{ MODKEY,                   XK_period,         focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,         XK_comma,          tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,         XK_period,         tagmon,         {.i = +1 } },
	{ MODKEY|ALTKEY,            XK_BackSpace,      quit,           {1} },
	{ MODKEY|ALTKEY|ShiftMask,  XK_q,              quit,           {0} },
	TAGKEYS(                    XK_1,                              0)
	TAGKEYS(                    XK_2,                              1)
	TAGKEYS(                    XK_3,                              2)
	TAGKEYS(                    XK_4,                              3)
	TAGKEYS(                    XK_5,                              4)
	TAGKEYS(                    XK_6,                              5)
	TAGKEYS(                    XK_7,                              6)
	TAGKEYS(                    XK_8,                              7)
	TAGKEYS(                    XK_9,                              8)
	TAGKEYS(                    XK_0,                              9)
	{ MODKEY,                   XK_1,              focusbynum,     {.i = 0} },
	{ MODKEY,                   XK_2,              focusbynum,     {.i = 1} },
	{ MODKEY,                   XK_3,              focusbynum,     {.i = 2} },
	{ MODKEY,                   XK_4,              focusbynum,     {.i = 3} },
	{ MODKEY,                   XK_5,              focusbynum,     {.i = 4} },
	{ MODKEY,                   XK_6,              focusbynum,     {.i = 5} },
	{ MODKEY,                   XK_7,              focusbynum,     {.i = 6} },
	{ MODKEY,                   XK_8,              focusbynum,     {.i = 7} },
	{ MODKEY|ShiftMask,	    XK_z,	       unfloatvisible, {0} },
	// { MODKEY|ShiftMask,	    XK_t,              unfloatvisible, {.v = &layouts[1]} },
	/* custom shortcuts */
	{ MODKEY,                   XK_space,          spawn,          {.v = dmenucmd } },
	{ MODKEY|ALTKEY,            XK_p,              spawn,          {.v = passmenucmd } },
	{ MODKEY,                   XK_period,         spawn,          {.v = rofiemoji } },
	{ MODKEY,                   XK_grave,          spawn,          SHCMD("powerRofi.sh") },
	{ MODKEY|ShiftMask,         XK_s,              spawn,          SHCMD("flameshot gui") },
	{ MODKEY,                   XK_l,              spawn,          SHCMD("betterlockscreen -l") },
	{ MODKEY|ALTKEY,            XK_r,              spawn,          SHCMD("xset r rate 210 40") },
	{ MODKEY|ShiftMask,         XK_grave,          spawn,          SHCMD("systemctl hibernate") },
	{ MODKEY,                   XK_Return,         spawn,          CMD(TERMINAL) },
	{ MODKEY,                   XK_e,              spawn,          CMD(FILEMANAGER) },
	{ MODKEY,                   XK_f,              spawn,          CMD("firefox-developer-edition") },
	{ MODKEY,                   XK_z,              spawn,          CMD("zen-browser") },
	{ MODKEY,                   XK_b,              spawn,          CMD("brave") },
	{ MODKEY,                   XK_t,              spawn,          CMD("thorium-browser") },
	{ MODKEY,                   XK_n,              spawn,          CMD("nitrogen") },
	{ MODKEY,                   XK_v,              spawn,          CMD("xfce4-popup-clipman") },

};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static const Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },

	{ ClkLtSymbol,          0,              Button4,        focusstack,     {.i = +1 } },
	{ ClkLtSymbol,          0,              Button5,        focusstack,     {.i = -1 } },

	{ ClkWinTitle,          0,              Button2,        killclient,     {0} },
	{ ClkWinTitle,          0,              Button4,        focusstack,     {.i = +1 } },
	{ ClkWinTitle,          0,              Button5,        focusstack,     {.i = -1 } },

	{ ClkStatusText,        0,              Button1,        sigstatusbar,   {.i = 1} },
	{ ClkStatusText,        0,              Button2,        sigstatusbar,   {.i = 2} },
	{ ClkStatusText,        0,              Button3,        sigstatusbar,   {.i = 3} },
	{ ClkStatusText,        0,              Button4,        sigstatusbar,   {.i = 4} },
	{ ClkStatusText,        0,              Button5,        sigstatusbar,   {.i = 5} },

	{ ClkClientWin,         MODKEY,         Button1,        moveorplace,    {.i = 2} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },

	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button2,        killclient,     {.ui = 2 } },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },

	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};
