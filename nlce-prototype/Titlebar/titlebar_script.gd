extends Control
class_name Titlebar

signal open_settings()

@onready var h_box_container_2: HBoxContainer = $MarginContainer/HBoxContainer/Control3/HBoxContainer2
@onready var label: Label = $MarginContainer/HBoxContainer/Control/HBoxContainer3/MarginContainer/HBoxContainer/Label

### MENU BUTTONS
@onready var file_menu_button: MenuButton = $MarginContainer/HBoxContainer/Control/HBoxContainer3/PanelContainer/MarginContainer/HBoxContainer/FileMenuButton
@onready var edit_menu_button: MenuButton = $MarginContainer/HBoxContainer/Control/HBoxContainer3/PanelContainer/MarginContainer/HBoxContainer/EditMenuButton
@onready var settings_menu_button: MenuButton = $MarginContainer/HBoxContainer/Control/HBoxContainer3/PanelContainer/MarginContainer/HBoxContainer/SettingsMenuButton
@onready var view_menu_button: MenuButton = $MarginContainer/HBoxContainer/Control/HBoxContainer3/PanelContainer/MarginContainer/HBoxContainer/ViewMenuButton
@onready var help_menu_button: MenuButton = $MarginContainer/HBoxContainer/Control/HBoxContainer3/PanelContainer/MarginContainer/HBoxContainer/HelpMenuButton

@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer/Control/HBoxContainer3/PanelContainer/MarginContainer/HBoxContainer


var following = false
var dragging_start_position = Vector2()

@export var window_name:String = "Title"
@export var buttons_area_minimum_size:float = 20.

@export var corner_radius_top_left:int = 0
@export var corner_radius_top_right:int = 0
@export var corner_radius_bottom_right:int = 0
@export var corner_radius_bottom_left:int = 0
@onready var panel: Panel = $Panel





func _ready() -> void:
	h_box_container_2.custom_minimum_size = Vector2(buttons_area_minimum_size,0.)
	set_menu_content_margins(5,5,5,5,5,5,5,5)
	_connect_menu_buttons()
	if window_name and label: label.text = window_name
	if panel:
		var style:StyleBoxFlat = panel.get_theme_stylebox("panel")
		style.corner_radius_bottom_left = corner_radius_bottom_left
		style.corner_radius_bottom_right = corner_radius_bottom_right
		style.corner_radius_top_left = corner_radius_top_left
		style.corner_radius_top_right = corner_radius_top_right

func _process(_delta):
	if following:
		DisplayServer.window_set_position(Vector2(DisplayServer.window_get_position()) + get_global_mouse_position() - dragging_start_position)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			following = !following
			dragging_start_position = get_local_mouse_position()





func _on_close_button_up() -> void:
	get_tree().quit()

func _on_maximize_button_up() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED :
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	else :
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_minimize_button_up() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)


func set_menu_content_margins(left: int,right: int,top: int,bottom: int,popup_left: int = left,popup_right: int = right,popup_top: int = top,popup_bottom: int = bottom):
	for child in h_box_container.get_children():
		if child is MenuButton:
			# Handle MenuButton states
			for state in ["normal", "hover", "pressed", "disabled", "focus"]:
				var stylebox = child.get_theme_stylebox(state)
				if !stylebox:
					continue

				var modified_style = stylebox.duplicate()
				modified_style.content_margin_left = left
				modified_style.content_margin_right = right
				modified_style.content_margin_top = top
				modified_style.content_margin_bottom = bottom
				child.add_theme_stylebox_override(state, modified_style)

			# Handle PopupMenu

			var popup = child.get_popup()
			if popup:
				# Create or modify PopupMenu style
				var popup_style = popup.get_theme_stylebox("panel")
				if !popup_style:
					popup_style = StyleBoxFlat.new()
					popup_style.bg_color = Color(0.1, 0.1, 0.1)

				popup_style = popup_style.duplicate()
				popup_style.content_margin_left = popup_left
				popup_style.content_margin_right = popup_right
				popup_style.content_margin_top = popup_top
				popup_style.content_margin_bottom = popup_bottom

				popup.add_theme_stylebox_override("panel", popup_style)

				# Add item margin (through custom constant)
				popup.add_theme_constant_override("item_margin", popup_left)


func _connect_menu_buttons():
	# File Menu
	var file_popup = file_menu_button.get_popup()
	file_popup.id_pressed.connect(_on_file_item_selected)

	# Edit Menu
	var edit_popup = edit_menu_button.get_popup()
	edit_popup.id_pressed.connect(_on_edit_item_selected)

	# Settings Menu
	var settings_popup = settings_menu_button.get_popup()
	settings_popup.id_pressed.connect(_on_settings_item_selected)

	# View Menu
	var view_popup = view_menu_button.get_popup()
	view_popup.id_pressed.connect(_on_view_item_selected)

	# Help Menu
	var help_popup = help_menu_button.get_popup()
	help_popup.id_pressed.connect(_on_help_item_selected)

### FILE

func _on_file_item_selected(id: int):
	match id:
		0: file_open_file()
		1: file_open_recent()
		2: file_save()
		3: file_save_as()
		4: file_reload()
		_: printerr("Unknown file menu ID:", id)

# File Operations Implementation
func file_open_file():
	"""
	var file_dialog = FileDialog.new()
	file_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.set_use_native_dialog(true)

	add_child(file_dialog)

	file_dialog.file_selected.connect(_on_file_dialog_open_selected)
	file_dialog.popup_centered_ratio()
	"""
	FileManager.open_selected_file("")
func _on_file_dialog_open_selected(path: String):
	FileManager.open_selected_file(path)

func file_open_recent():

	var recent_files = _get_recent_files()
	if recent_files.is_empty():
		print("No recent files found")
		return

	# Create popup menu for recent files
	var popup = PopupMenu.new()
	add_child(popup)

	for i in recent_files.size():
		popup.add_item(recent_files[i], i)

	popup.id_pressed.connect(
		func(id):
			print("Opening recent:", recent_files[id])
			# Add your loading logic here
			popup.queue_free()
	)

	popup.popup_centered_ratio(0.3)

func file_save():
	FileManager.save_file()
	if not _has_current_file():
		file_save_as()
		return




func file_save_as():
	FileManager.save_file_as("")

func _on_file_dialog_save_selected(path: String):
	FileManager.save_file_as(path)
	_update_current_file_path(path)


func file_reload(): #TODO
	if not _has_current_file():
		printerr("No file to reload")
		return

	print("Reloading current file")


# Helper Functions
func _get_recent_files() -> Array[String]:
	return FileManager.get_recent_files()

func _has_current_file() -> bool:
	return FileManager.current_file_path != ""

func _get_current_file_path() -> String:
	return FileManager.current_file_path

func _update_current_file_path(path: String):
	FileManager.current_file_path = path


### EDIT

func _on_edit_item_selected(id: int):
	match id:
		0: print("Edit: Undo selected")
		1: print("Edit: Redo selected")




### SETTINGS
func _on_settings_item_selected(id: int):
	match id:
		0: settings_preferences()

func settings_preferences():
	emit_signal("open_settings")


### VIEW
func _on_view_item_selected(id: int):
	match id:
		0: print("View: Show Timeline selected") #TODO
		1: print("View: View Intra-connections selected") #TODO




### HELP
func _on_help_item_selected(id: int):
	match id:
		0: print("Help: Documentation selected") #TODO
		1: print("Help: About selected") #TODO
		2: pass #TODO
		3:OS.shell_open("https://github.com/MarageDev/NonLinearCodeEditor-Prototype")
		4:OS.shell_open("https://discordapp.com/users/729076099274768414")
