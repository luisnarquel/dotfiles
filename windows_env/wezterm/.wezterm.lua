local wezterm = require("wezterm")
local act = wezterm.action
local opacity = 1
local transparent_bg = "rgba(22, 24, 26, " .. opacity .. ")"

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Color Configuration
config.colors = {
    foreground = "#ffffff",
    background = "#16181a",

    cursor_bg = "#ffffff",
    cursor_fg = "#16181a",
    cursor_border = "#ffffff",

    selection_fg = "#ffffff",
    selection_bg = "#3c4048",

    scrollbar_thumb = "#16181a",
    split = "#16181a",

    ansi = { "#16181a", "#ff6e5e", "#5eff6c", "#f1ff5e", "#5ea1ff", "#bd5eff", "#5ef1ff", "#ffffff" },
    brights = { "#3c4048", "#ff6e5e", "#5eff6c", "#f1ff5e", "#5ea1ff", "#bd5eff", "#5ef1ff", "#ffffff" },
    indexed = { [16] = "#ffbd5e", [17] = "#ff6e5e" },
}

-- https://wezfurlong.org/wezterm/colorschemes/index.html
config.color_scheme = 'Catppuccin Mocha'

config.default_cursor_style = "SteadyBar"
config.automatically_reload_config = true
config.window_close_confirmation = "NeverPrompt"
config.adjust_window_size_when_changing_font_size = false
config.window_decorations = "RESIZE"
config.check_for_updates = false
config.disable_default_key_bindings = true
config.font_size = 11
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

-- Performance Settings
config.max_fps = 120
config.animation_fps = 30

-- Tab Bar Configuration
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.show_tab_index_in_tab_bar = false
config.use_fancy_tab_bar = false
config.show_new_tab_button_in_tab_bar = false
config.colors.tab_bar = {
    background = config.window_background_image and "rgba(0, 0, 0, 0)" or transparent_bg,
    new_tab = { fg_color = config.colors.background, bg_color = config.colors.brights[6] },
    new_tab_hover = { fg_color = config.colors.background, bg_color = config.colors.foreground },
}

-- Tab Formatting
wezterm.on("format-tab-title", function(tab, _, _, _, hover)
    local background = config.colors.brights[1]
    local foreground = config.colors.foreground

    if tab.is_active then
        background = config.colors.brights[7]
        foreground = config.colors.background
    elseif hover then
        background = config.colors.brights[8]
        foreground = config.colors.background
    end

    local title = tostring(tab.tab_index + 1)
    return {
        { Foreground = { Color = background } },
        { Text = "█" },
        { Background = { Color = background } },
        { Foreground = { Color = foreground } },
        { Text = title },
        { Foreground = { Color = background } },
        { Text = "█" },
    }
end)

config.keys = {
	-- paste
	{ key = 'V', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },

	-- tab navigation
	{ key = 'LeftArrow',  mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
	{ key = 'RightArrow', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(1) },

	-- New tabs open in /mnt/c by default
	{
		key = "T",
		mods = "CTRL|SHIFT",
		action = act.SpawnCommandInNewTab({
			domain = { DomainName = "WSL:Ubuntu" },
			cwd = "/mnt/c",
		}),
	},

	-- Close current tab without confirmation
	{
		key = "W",
		mods = "CTRL|SHIFT",
		action = act.CloseCurrentTab({ confirm = false }),
	},

	-- Split horizontally and vertically
	{
		key = "D",
		mods = "CTRL|SHIFT",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "E",
		mods = "CTRL|SHIFT",
		action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
	},

	-- Focus next/previous split
	{ key = "LeftArrow", mods = "CTRL", action = act.ActivatePaneDirection "Left" },
	{ key = "RightArrow", mods = "CTRL", action = act.ActivatePaneDirection "Right" },
	{ key = "UpArrow", mods = "CTRL", action = act.ActivatePaneDirection "Up" },
	{ key = "DownArrow", mods = "CTRL", action = act.ActivatePaneDirection "Down" },

}

-- There are mouse binding to mimc Windows Terminal and let you copy on right click and paste if there is no selection
mouse_bindings = {
  {
    event = { Down = { streak = 3, button = 'Left' } },
    mods = 'NONE',
    action = act.SelectTextAtMouseCursor 'SemanticZone',
  },
  {
    event = { Down = { streak = 1, button = "Right" } },
    mods = "NONE",
    action = wezterm.action_callback(function(window, pane)
      local has_selection =
        window:get_selection_text_for_pane(pane) ~= ""

      if has_selection then
        window:perform_action(
          act.CopyTo("ClipboardAndPrimarySelection"),
          pane
        )
        window:perform_action(act.ClearSelection, pane)
      else
        window:perform_action(
          act.PasteFrom("Clipboard"),
          pane
        )
      end
    end),
  },
  {
  	event = { Down = { streak = 1, button = "Left" } },
  	mods = "ALT",
  	action = act.StartWindowDrag,
	},
}

config.mouse_bindings = mouse_bindings

-- Start centered
wezterm.on("gui-startup", function(cmd)
  local screen = wezterm.gui.screens().active
  local ratio = 0.4
  local width, height = screen.width * ratio, screen.height * ratio
  local tab, pane, window = wezterm.mux.spawn_window {
    position = {
      x = (screen.width - width) / 2,
      y = (screen.height - height) / 2,
      origin = 'ActiveScreen' }
  }
  window:gui_window():set_inner_size(width, height)
end)

config.foreground_text_hsb = {
  hue = 1.0,
  saturation = 1.2,
  brightness = 1.5,
}

config.background = {
    {
        source = { File = {path = 'C:/Users/luis.narquel/.config/wezterm/bg-blurred.png', speed = 0.2}},
 opacity = 0.75,
 width = "100%",
 hsb = {brightness = 0.5},
    }
}

config.default_domain = "WSL:Ubuntu"
config.wsl_domains = {
    {
        name = 'WSL:Ubuntu',
        distribution = 'Ubuntu',
        default_cwd = '/mnt/c'
    }
}

return config