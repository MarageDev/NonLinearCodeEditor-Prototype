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
