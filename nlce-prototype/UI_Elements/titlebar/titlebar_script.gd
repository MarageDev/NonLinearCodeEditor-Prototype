@tool
extends Control

var following = false
var dragging_start_position = Vector2()
@export var window_name:String = "Title"
@export var buttons_area_minimum_size:float = 20.
@onready var h_box_container_2: HBoxContainer = $MarginContainer/HBoxContainer/Control3/HBoxContainer2
@onready var label: Label = $MarginContainer/HBoxContainer/Control/HBoxContainer3/MarginContainer/Label
@export var corner_radius_top_left:int = 0
@export var corner_radius_top_right:int = 0
@export var corner_radius_bottom_right:int = 0
@export var corner_radius_bottom_left:int = 0
@onready var panel: Panel = $Panel

@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer/Control/HBoxContainer3/PanelContainer/MarginContainer/HBoxContainer

func _ready() -> void:
	set_menu_content_margins(5,5,5,5,5,5,5,5)
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.get_button_index() == 1:
			following = !following
			dragging_start_position = get_local_mouse_position()


func _process(_delta):
	if following:
		DisplayServer.window_set_position(Vector2(DisplayServer.window_get_position()) + get_global_mouse_position() - dragging_start_position)
	h_box_container_2.custom_minimum_size = Vector2(buttons_area_minimum_size,0.)
	if window_name and label: label.text = window_name
	if panel:
		var style:StyleBoxFlat = panel.get_theme_stylebox("panel")
		style.corner_radius_bottom_left = corner_radius_bottom_left
		style.corner_radius_bottom_right = corner_radius_bottom_right
		style.corner_radius_top_left = corner_radius_top_left
		style.corner_radius_top_right = corner_radius_top_right

func _on_close_button_up() -> void:
	get_tree().quit()


func _on_maximize_button_up() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED :
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	else :
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_minimize_button_up() -> void:
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MINIMIZED)

@onready var menu_button: MenuButton = $MarginContainer/HBoxContainer/HBoxContainer/Menu/MenuButton
func _on_menu_button_up() -> void:
	menu_button.show()
	menu_button.button_down

func set_menu_content_margins(
	left: int,
	right: int,
	top: int,
	bottom: int,
	popup_left: int = left,
	popup_right: int = right,
	popup_top: int = top,
	popup_bottom: int = bottom
):
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
