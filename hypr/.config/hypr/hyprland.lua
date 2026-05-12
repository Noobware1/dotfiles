require("monitor")
require("autostart")
require("environment")
require("programs")
require("permissions")
require("animations")
require("gestures")
require("keybinds")
require("window_rules")
require("colors")

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		col = {
			active_border = M3_secondary_container,
			inactive_border = M3_outline,
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",

	},

	decoration = {
		rounding         = 10,
		rounding_power   = 2,
		active_opacity   = 1.0,
		inactive_opacity = 1.0,
		shadow           = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = "rgba(1a1a1aee)"
		},
		blur             = {
			enabled = true,
			size = 3,
			passes = 1,
			vibrancy = 0.1696,
		}
	},
	animations = {
		enabled = true
	},
	dwindle = {
		preserve_split = true,
	},
	scrolling = {
		fullscreen_on_one_column = true,
	},
	misc = {
		force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
		disable_hyprland_logo   = true, -- If true disables the random hyprland logo / anime girl background. :(
	},
	input = {
		kb_layout    = "us",
		kb_variant   = "",
		kb_model     = "",
		kb_options   = "",
		kb_rules     = "",

		follow_mouse = 1,

		sensitivity  = 0, -- -1.0 - 1.0, 0 means no modification.

		touchpad     = {
			natural_scroll = false,
		},
	},
})
