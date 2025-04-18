extends Control

@export var file_path: String = ""
@export var separators: Array[String] = []
@onready var graph_edit: GraphEdit = $GraphEdit

func _ready() -> void:
	var blocks: Array[String] = SeparateCodeBlocksInFile(file_path, separators)
	for i in blocks:
		var newGraphCodeNode: GraphCodeNode = preload("res://Node/SingleCodeNode/SingleCodeNode.tscn").instantiate()
		newGraphCodeNode.node_title = str(randi_range(0, 999))
		newGraphCodeNode.node_content = i
		graph_edit.add_child(newGraphCodeNode)
		print(i)

func SeparateCodeBlocksInFile(file_path: String, separators: Array) -> Array[String]:
	var blocks: Array[String] = []
	var current_block: Array[String] = []
	var string_separators: Array[String] = []
	var regex_separators: Array[RegEx] = []

	# Separate plain strings and regex patterns
	for sep in separators:
		if typeof(sep) == TYPE_STRING and sep.begins_with("re:"):
			var pattern = sep.substr(3)  # Remove "re:" prefix
			var regex = RegEx.new()
			var err = regex.compile(pattern)
			if err == OK:
				regex_separators.append(regex)
			else:
				push_error("Invalid regex pattern: %s" % pattern)
		else:
			string_separators.append(sep)

	if not FileAccess.file_exists(file_path):
		return []

	var file = FileAccess.open(file_path, FileAccess.READ)
	while not file.eof_reached():
		var line = file.get_line()
		var is_separator = false

		# Check string separators
		for sep in string_separators:
			if line.strip_edges().begins_with(sep):
				is_separator = true
				break

		# Check regex separators if not already matched
		if not is_separator:
			for regex in regex_separators:
				if regex.search(line):
					is_separator = true
					break

		if is_separator:
			_finalize_block(current_block, blocks)
			current_block = [line]  # Start new block with separator line
		else:
			current_block.append(line)

	_finalize_block(current_block, blocks)  # Add remaining content
	file.close()
	return blocks

# Helper to finalize and add a block if not empty
func _finalize_block(current_block: Array[String], blocks: Array[String]) -> void:
	if current_block.size() > 0:
		blocks.append("\n".join(current_block))
