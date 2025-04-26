extends Control
class_name WorkspaceClass
@export var file_path: String = ""
@export var separators: Array = []
@onready var graph_edit: GraphEdit = $GraphEdit

var code_graph_nodes:Array[CodeNodeClass] = []

func _ready() -> void:
	FileManager.workspace = self

	#var blocks: Array = SeparateCodeBlocksInFile(file_path, separators)
	#spawn_nodes_in_grid(blocks, graph_edit, "res://Node/SingleCodeNode/SingleCodeNode.tscn",3)

func spawn_nodes_in_grid(blocks: Array, graph_edit: GraphEdit, node_scene_path: String, nodes_per_row: int = 4, spacing: Vector2 = Vector2(40, 40)) -> void:
	var default_size:Vector2 = Vector2(300,300)
	for i in range(blocks.size()):
		var newGraphCodeNode: CodeNodeClass = load(node_scene_path).instantiate()
		newGraphCodeNode.node_index = i
		newGraphCodeNode.node_content = blocks[i]
		graph_edit.add_child(newGraphCodeNode)
		code_graph_nodes.append(newGraphCodeNode)
		var row := i / nodes_per_row
		var col := i % nodes_per_row
		var pos := Vector2(
			col * (default_size.x + spacing.x),
			row * (default_size.y + spacing.y)
		)
		newGraphCodeNode.position_offset = pos
		newGraphCodeNode.owner = graph_edit	# Use this to make it save-able in resource


func SeparateCodeBlocksInFile(file_path: String, separators: Array) -> Array:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		push_error("Could not open file: %s" % file_path)
		return []

	var blocks = []
	var current_block = []
	var in_block = false
	var block_indent = 0

	while not file.eof_reached():
		var line = file.get_line()
		var stripped = line.lstrip(" \t")

		# Check if this line starts a new block
		var is_separator = false
		for sep in separators:
			if stripped.begins_with(sep):
				is_separator = true
				break

		# If it's a separator, start a new block
		if is_separator:
			if current_block.size() > 0:
				blocks.append("\n".join(current_block))
				current_block.clear()
			current_block.append(line)
			in_block = true
			block_indent = line.length() - stripped.length()
		elif in_block:
			# If indented or empty, it's part of the current block
			var indent = line.length() - stripped.length()
			if indent > block_indent or stripped == "":
				current_block.append(line)
			else:
				# New top-level line, end current block
				blocks.append("\n".join(current_block))
				current_block.clear()
				in_block = false
				# This line may be a new block or not
				if stripped != "":
					current_block.append(line)
		else:
			# Not in a block, just accumulate until a separator is found
			current_block.append(line)

	# Add any remaining block
	if current_block.size() > 0:
		blocks.append("\n".join(current_block))

	file.close()
	return blocks


func _input(event):
	var framed_nodes: Array[CodeNodeClass] = []
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		framed_nodes.clear()
		for child in graph_edit.get_children():
			if child is GraphNode and child.selected:
				framed_nodes.append(child)
		frame_selected_nodes(framed_nodes)
func frame_selected_nodes(framed_nodes):
	var dynamic_frame:RectFrameClass = null

	if framed_nodes.size() == 0:
		return

	dynamic_frame = preload("res://RectFrame/RectFrame.tscn").instantiate()
	dynamic_frame.title = "Group " + str(randi_range(0, 999))
	dynamic_frame.set_framed_nodes(framed_nodes)
	graph_edit.add_child(dynamic_frame)
	dynamic_frame.owner = graph_edit


func _unhandled_input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_C:
		create_color_wheel()

func _handle_color_change(new_color:Color):
	var selected_nodes:Array = []
	for i in graph_edit.get_children():
			if i is CodeNodeClass or i is RectFrameClass :
				if i.selected:
					selected_nodes.append(i)
	for i in selected_nodes:
		if i is CodeNodeClass:
			i.set_graphnode_color(new_color)
		elif i is CodeNodeClass:
			i.set_frame_color(new_color)
		else: continue




var currentColorWheel:RectFrameClass

func create_color_wheel():
	if currentColorWheel : currentColorWheel.queue_free()
	var newColorWheel:RectFrameClass = preload("res://ColorWheel/ColorWheel.tscn").instantiate()
	newColorWheel.global_position = get_global_mouse_position() + Vector2(-1.,-1.)*newColorWheel.size/2.
	add_child(newColorWheel)
	newColorWheel.color_changed.connect(_handle_color_change)
	currentColorWheel = newColorWheel
