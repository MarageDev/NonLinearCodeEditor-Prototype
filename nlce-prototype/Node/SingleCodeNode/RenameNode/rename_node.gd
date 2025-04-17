extends Control
@onready var line_edit: LineEdit = $Panel/LineEdit

signal text_submitted(new_text)
var followed_node:Control
var following_offset:Vector2
func _process(delta: float) -> void:
	position = followed_node.global_position + following_offset

func _on_line_edit_text_submitted(new_text: String) -> void:
	emit_signal("text_submitted",new_text)
	self.queue_free()


func _on_line_edit_focus_exited() -> void:
	self.queue_free()
