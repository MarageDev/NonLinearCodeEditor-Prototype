extends Button
class_name CustomMenuButton
@export var button_title:String = ""
@export var attached_button_info:String = ""
@onready var label: Label = $MarginContainer/HBoxContainer/Label
@onready var label_2: Label = $MarginContainer/HBoxContainer/Label2

func _ready() -> void:
	if label and label_2 :
		label.text = button_title
		label_2.text = attached_button_info
