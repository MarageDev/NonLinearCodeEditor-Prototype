extends MenuButton

var popup_menu: PopupMenu
var file_submenu: PopupMenu = PopupMenu.new()
var settings_submenu: PopupMenu = PopupMenu.new()

func _ready():
	popup_menu = self.get_popup()
	popup_menu.submenu_popup_delay = 0.0

	# Set content margins for main popup menu
	_set_popup_margins(popup_menu)

	popup_menu.add_item("Reload File")
	popup_menu.add_separator("")
	_build_popup_menu_file()

	_build_popup_menu_settings()

func _build_popup_menu_file():
	file_submenu.name = "file_submenu"
	file_submenu.submenu_popup_delay = 0.0

	# Set content margins for file submenu
	_set_popup_margins(file_submenu)

	popup_menu.add_child(file_submenu)
	popup_menu.add_submenu_item("File", file_submenu.name)
	file_submenu.add_item("Load File")
	file_submenu.add_item("Save")
	file_submenu.add_item("Save As...")

func _build_popup_menu_settings():
	settings_submenu.name = "settings_submenu"
	settings_submenu.submenu_popup_delay = 0.0

	# Set content margins for settings submenu
	_set_popup_margins(settings_submenu)

	popup_menu.add_child(settings_submenu)
	popup_menu.add_submenu_item("Settings", settings_submenu.name)
	settings_submenu.add_item("Open Settings")
	settings_submenu.add_item("Reset Settings")

func _set_popup_margins(menu: PopupMenu):

	var stylebox = menu.get_theme_stylebox("panel").duplicate()

	stylebox.content_margin_left = 5
	stylebox.content_margin_top = 5
	stylebox.content_margin_right = 5
	stylebox.content_margin_bottom = 5

	menu.add_theme_stylebox_override("panel", stylebox)
