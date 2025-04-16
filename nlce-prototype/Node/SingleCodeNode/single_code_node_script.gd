extends GraphNode
class_name GraphCodeNode
@export var node_index:int = 0
@export var node_title:String = "Title"
@export var node_content:String = ""
@export var code_edit:CodeEdit
func _ready() -> void:
	await get_tree()
	if node_title : title = str(node_index) +" - "+node_title

	if node_content and code_edit : code_edit.text = node_content



func _on_resize_request(new_size: Vector2) -> void:
	code_edit.scroll_fit_content_height = false
	code_edit.scroll_fit_content_width = false
