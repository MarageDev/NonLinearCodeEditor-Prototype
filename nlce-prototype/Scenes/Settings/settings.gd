extends Control
@onready var fps_spin_box: SpinBox = $Panel/Panel/ScrollContainer/MarginContainer/VBoxContainer/HBoxContainer/FPS_SpinBox

func _ready() -> void:
	_on_fps_spin_box_value_changed(fps_spin_box.value)
	_on_option_button_item_selected(1)


func _on_fps_spin_box_value_changed(value: float) -> void:
	Engine.max_fps = value


func _on_option_button_item_selected(index: int) -> void:
	if index == 0 :
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else :
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_panel_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		queue_free()
