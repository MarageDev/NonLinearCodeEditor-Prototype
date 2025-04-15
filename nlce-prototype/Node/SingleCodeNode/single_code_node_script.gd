@tool
extends GraphNode

@export var node_title:String = "Title"
@export var node_content:String = ""

@onready var code_edit: CodeEdit = $MarginContainer/CodeEdit

"""
def print_to_screen():
	var a = "hello world !"
	print(a)
	print('This print is now complete')
	return a
"""

func _ready() -> void:
	if node_title : title = node_title
