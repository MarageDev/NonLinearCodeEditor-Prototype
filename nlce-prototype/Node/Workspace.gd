extends Control

@export var file_path: String = ""
@export var separators: Array = []
@onready var graph_edit: GraphEdit = $GraphEdit

func _ready() -> void:
	var blocks: Array = SeparateCodeBlocksInFile(file_path, separators)
	for i in range(len(blocks)):
		var newGraphCodeNode: GraphCodeNode =load("res://Node/SingleCodeNode/SingleCodeNode.tscn").instantiate()
		newGraphCodeNode.node_index = i
		newGraphCodeNode.node_title = "title"
		newGraphCodeNode.node_content = blocks[i]
		graph_edit.add_child(newGraphCodeNode)
		newGraphCodeNode.position_offset = DisplayServer.window_get_size()/2. - newGraphCodeNode.size/2.
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
