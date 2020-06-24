import nuke
import nuke_utils.quickies as _quickies

# Menu creation for `WGID Scripts`
__top_menu = nuke.menu("Nuke").addMenu("&WDIG Scripts")


# Append Tools
__top_menu.addComment("Set Localization/On", lambda: _quickies.set_localization(0))
__top_menu.addComment("Set Localization/Off", lambda: _quickies.set_localization(3))
