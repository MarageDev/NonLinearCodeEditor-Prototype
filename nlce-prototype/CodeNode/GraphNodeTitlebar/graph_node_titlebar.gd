extends Panel
class_name GraphNodeTitlebarClass

signal double_clicked(position)

const DOUBLE_CLICK_TIME = 0.3
var last_click_time = 0.0

@onready var label: Label = $HBoxContainer/Label
@onready var label_number: Label = $HBoxContainer/Label_number

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var current_time = Time.get_ticks_msec() / 1000.0
		if current_time - last_click_time <= DOUBLE_CLICK_TIME:
			_on_double_click(event)
			last_click_time = 0.0 # Reset to avoid triple clicks
		else:
			last_click_time = current_time

func _on_double_click(event):
	emit_signal("double_clicked", event.position)
