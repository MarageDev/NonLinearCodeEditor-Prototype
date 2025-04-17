extends GraphNode
class_name GraphCodeNode

@export var node_content:String = ""
@export var code_edit:CodeEdit

var node_index:int = 0

var custom_title_bar:CustomGraphNodeTitlebar

func _ready() -> void:
	await get_tree()

	if node_content and code_edit : code_edit.text = node_content

	setup_custom_titlebar(self)

func _on_resize_request(new_size: Vector2) -> void:
	code_edit.scroll_fit_content_height = false
	code_edit.scroll_fit_content_width = false

func setup_custom_titlebar(graph_node:GraphNode):

	var default_stylebox = graph_node.get_theme_stylebox("titlebar")
	if default_stylebox is not StyleBoxFlat : return

	var new_stylebox:StyleBoxFlat = default_stylebox.duplicate()
	var titlebar:HBoxContainer = graph_node.get_titlebar_hbox()

	new_stylebox.content_margin_top = 4
	new_stylebox.content_margin_bottom = 4
	new_stylebox.content_margin_left = 8
	new_stylebox.content_margin_right = 8
	graph_node.add_theme_stylebox_override("titlebar", new_stylebox)

	# Rmoeve the defualt title
	for i in titlebar.get_children():
		titlebar.remove_child(i)

	var custom_titlebar_node:CustomGraphNodeTitlebar = preload("res://Node/SingleCodeNode/CustomGraphNodeTitlebar/CustomGraphNodeTitlebar.tscn").instantiate()
	titlebar.alignment = BoxContainer.ALIGNMENT_CENTER
	titlebar.add_child(custom_titlebar_node)
	titlebar.move_child(custom_titlebar_node,0)
	custom_titlebar_node.double_clicked.connect(_on_titlebar_double_clicked)
	custom_title_bar = custom_titlebar_node

	custom_titlebar_node.label_number.text = str(node_index)
func _on_titlebar_double_clicked(pos:Vector2):
	var margin:float = 15.
	var rename:Control = preload("res://Node/SingleCodeNode/RenameNode/rename_node.tscn").instantiate()
	var parent := get_parent()
	var global_pos = get_global_position()
	rename.position = global_pos + Vector2(0.,-1.)*(rename.size.y+margin)
	rename.followed_node = self
	rename.following_offset = Vector2(0.,-1.)*(rename.size.y+margin)
	parent.add_child(rename)
	rename.line_edit.grab_focus()
	rename.text_submitted.connect(_node_title_edit)

func _node_title_edit(new_text:String):
	if new_text != null : custom_title_bar.label.text = new_text
