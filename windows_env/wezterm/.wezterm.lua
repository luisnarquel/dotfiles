local wezterm = require("wezterm")

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end


--TODO remove when running on windows
config.front_end = "WebGpu"

config.default_cursor_style = "SteadyBar"
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
config.check_for_updates = false
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.font_size = 12.5
config.font = wezterm.font({
  family = "JetBrainsMono Nerd Font",
  weight = "Bold",
})
config.enable_tab_bar = false
config.window_padding = {
	left = 7,
	right = 0,
	top = 2,
	bottom = 0,
}

config.default_domain = "WSL:Ubuntu"

-- https://wezfurlong.org/wezterm/colorschemes/index.html
config.color_scheme = 'Catppuccin Mocha'

return config