@tool
extends Control

var following = false
var dragging_start_position = Vector2()
@export var window_name:String = "Title"
@export var buttons_area_minimum_size:float = 20.
@onready var h_box_container_2: HBoxContainer = $MarginContainer/HBoxContainer/HBoxContainer2
@onready var label: Label = $MarginContainer/HBoxContainer/Label
@export var corner_radius_top_left:int = 0
@export var corner_radius_top_right:int = 0
@export var corner_radius_bottom_right:int = 0
@export var corner_radius_bottom_left:int = 0
@onready var panel: Panel = $Panel


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
