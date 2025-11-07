static const Rule rules[] = {
    /* xprop(1):
     *	WM_CLASS(STRING) = instance, class
     *	WM_NAME(STRING) = title
     */
    /* class	instance    title       tagsmask     isfloating   monitor */

    // Python Tkinter
    {"tk", NULL, NULL, 0, 1, -1},  // Allow tk on any workspace and make it floating
    {"Tk", NULL, NULL, 0, 1, -1},  // Allow Tk on any workspace and make it floating
    {"!toplevel",NULL, NULL, 0, 1, -1},
    {"Toplevel",NULL, NULL, 0, 1, -1},

    // Applications

    // Browsers
    {"firefox", NULL, NULL, 2, 0, -1},
    {"zen-alpha", NULL, NULL, 2, 0, -1},
    {"zen-beta", NULL, NULL, 2, 0, -1},
    {"zen", NULL, NULL, 2, 0, -1},
    {"brave-browser", NULL, NULL, 2, 0, -1},
    {"Brave-browser", NULL, NULL, 2, 0, -1},
    {"thorium-browser", NULL, NULL, 2, 0, -1},
    {"Thorium-browser", NULL, NULL, 2, 0, -1},

    {"dev.warp.Warp", NULL, NULL, 1, 0, -1},
    {"pcmanfm", NULL, NULL, 1 << 2, 0, -1},	// pcmanfm on 3rd workspace
    {"Pcmanfm", NULL, NULL, 1 << 2, 0, -1},	// Pcmanfm on 3rd workspace
    {"nemo", NULL, NULL, 1 << 2, 0, -1},	// Nemo on 3rd workspace
    {"Nemo", NULL, NULL, 1 << 2, 0, -1},	// Nemo on 3rd workspace
    {"discord", NULL, NULL, 1 << 3, 0, -1},	// Discord on 4th workspace
    {"bruno", NULL, NULL, 1 << 4, 0, -1},	// Discord on 4th workspace
    {"org.gnome.Nautilus", NULL, NULL, 1 << 2, 0, -1},	// Nautilus on 3rd workspace
    {"obsidian", NULL, NULL, 1 << 8, 0, -1},	// obsidian on 9th workspace
    {"amberol", NULL, NULL, 0, 1, -1},  // Allow amberol on any workspace and make it floating
    {"yad", NULL, NULL, 0, 1, -1},  // Allow yad on any workspace and make it floating
    {"Yad", NULL, NULL, 0, 1, -1},  // Allow Yad on any workspace and make it floating
    {"signal", NULL, NULL, 1 << 3, 0, -1},  // singal on 7th workspace
    {"Signal", NULL, NULL, 1 << 3, 0, -1},  // singal on 7th workspace
    {"Spotify", NULL, NULL, 1 << 7, 0, -1},  // Spotify on 8th workspace
};
