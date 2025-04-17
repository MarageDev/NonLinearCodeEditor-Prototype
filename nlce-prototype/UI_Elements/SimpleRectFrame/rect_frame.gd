extends GraphFrame
class_name RectGraphFrame

var framed_graph_nodes: Array[GraphNode] = []
var padding = Vector2(40, 40)
var last_position_offset := Vector2.ZERO
var is_dragging_frame := false
var ignore_frame_position_change := false

func _ready():
	last_position_offset = position_offset
	connect("position_offset_changed", Callable(self, "_on_frame_moved"))
	autoshrink_enabled = true
	autoshrink_margin = 40
	_update_frame_transform()
func set_framed_nodes(nodes: Array[GraphNode]):
	framed_graph_nodes = nodes
	for node in nodes:
		if not node.is_connected("position_offset_changed", Callable(self, "_on_node_moved")):
			node.connect("position_offset_changed", Callable(self, "_on_node_moved"))
	_update_frame_transform()
	last_position_offset = position_offset

var updating_from_nodes := false


func _update_frame_transform():
	if is_dragging_frame:
		return
	if framed_graph_nodes.size() == 0:
		return

	var min_pos = framed_graph_nodes[0].position_offset
	var max_pos = framed_graph_nodes[0].position_offset + framed_graph_nodes[0].size

	for node in framed_graph_nodes:
		min_pos = min_pos.min(node.position_offset)
		max_pos = max_pos.max(node.position_offset + node.size)

	updating_from_nodes = true
	position_offset = min_pos - padding
	size = (max_pos - min_pos) + padding * 2
	last_position_offset = position_offset
	updating_from_nodes = false

func _on_frame_moved():
	if updating_from_nodes:
		return
	var delta = position_offset - last_position_offset
	is_dragging_frame = true
	for node in framed_graph_nodes:
		node.position_offset += delta
	last_position_offset = position_offset
	is_dragging_frame = false

func _on_node_moved():
	_update_frame_transform()

const DOUBLE_CLICK_TIME = 0.3
var last_click_time = 0.0

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var current_time = Time.get_ticks_msec() / 1000.0
		if current_time - last_click_time <= DOUBLE_CLICK_TIME:
			_on_double_click(event)
			last_click_time = 0.0 # Reset to avoid triple clicks
		else:
			last_click_time = current_time


func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_BACKSPACE:
		_remove_frame()


func _on_double_click(event):
	var margin:float = 25.
	var rename:Control = preload("res://Node/SingleCodeNode/RenameNode/rename_node.tscn").instantiate()
	var global_pos = get_global_position()
	var parent = get_parent()

	rename.position = global_pos + Vector2(0.,-1.)*(rename.size.y+margin)
	rename.followed_node = self
	rename.following_offset = Vector2(0.,-1.)*(rename.size.y+margin)
	parent.add_child(rename)
	rename.line_edit.grab_focus()
	rename.text_submitted.connect(_frame_title_edit)

func _frame_title_edit(new_title):
	title = new_title

func _remove_frame():
	queue_free()

func set_frame_color(color:Color):
	tint_color_enabled = true
	tint_color = Color(color.r,color.g,color.b,120./255.)
