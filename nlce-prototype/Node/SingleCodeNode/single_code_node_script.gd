extends GraphNode
class_name GraphCodeNode

@export var node_content:String = ""
@export var code_edit:CodeEdit

@export var CodeNodeAssociatedResource:CodeNodeResource = CodeNodeResource.new()

@export var customColor:bool = false
@export var customNodeColor:Color = Color.WHITE

@export var node_index:int = 0

var custom_title_bar:CustomGraphNodeTitlebar

func _ready() -> void:
	await get_tree()

	if node_content and code_edit : code_edit.text = node_content

	setup_custom_titlebar(self)

	CodeNodeAssociatedResource.content = node_content
	CodeNodeAssociatedResource.code_index = node_index


func set_code_content(content:String):
	code_edit.text = content
func setup_node():
	setup_custom_titlebar(self)

	CodeNodeAssociatedResource.content = node_content
	CodeNodeAssociatedResource.code_index = node_index
	if node_content and code_edit : code_edit.text = node_content
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

func set_graphnode_color(color: Color):
	var stylebox_panel:StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	stylebox_panel.bg_color = Color.from_hsv(color.h,color.s,0.09)
	stylebox_panel.border_color = Color.from_hsv(color.h,color.s,0.14)
	add_theme_stylebox_override("panel", stylebox_panel)

	var stylebox_panel_selected:StyleBoxFlat = get_theme_stylebox("panel_selected").duplicate()
	stylebox_panel_selected.bg_color = Color.from_hsv(color.h,color.s,0.09)
	stylebox_panel_selected.border_color = Color.from_hsv(color.h,.44,.53)
	add_theme_stylebox_override("panel_selected", stylebox_panel_selected)

	var stylebox_titlebar:StyleBoxFlat = get_theme_stylebox("titlebar").duplicate()
	stylebox_titlebar.bg_color = Color.from_hsv(color.h,color.s,0.16)
	stylebox_titlebar.border_color = Color.from_hsv(color.h,color.s,0.14)
	add_theme_stylebox_override("titlebar", stylebox_titlebar)

	var stylebox_titlebar_selected:StyleBoxFlat = get_theme_stylebox("titlebar_selected").duplicate()
	stylebox_titlebar_selected.bg_color = Color.from_hsv(color.h,.58,0.45)
	stylebox_titlebar_selected.border_color = Color.from_hsv(color.h,.44,.53)
	add_theme_stylebox_override("titlebar_selected", stylebox_titlebar_selected)
