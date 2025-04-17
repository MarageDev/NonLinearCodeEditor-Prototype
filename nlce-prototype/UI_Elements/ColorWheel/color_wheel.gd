extends Control
class_name ColorWheel
@onready var color_wheel: ColorPicker = $Panel/VBoxContainer/MarginContainer/ColorWheel

signal color_changed(new_color)

func _ready() -> void:
	top_level = true


func _on_color_wheel_color_changed(color: Color) -> void:
	emit_signal("color_changed",color)
