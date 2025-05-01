extends Node

var workspace:WorkspaceClass

signal file_loaded(file_path:String)
signal graph_loaded(graph_data:GraphDataRes)
func open_selected_file(path:String):
	load_graph_manual_serialization(path)

func save_file():
	save_graph_manual_serialization(GlobalManager.graph_save.currentGraphPath)

var saved_file_path:String

func _on_file_dialog_save_selected(path: String): #TODO
	saved_file_path = path
	GlobalManager.graph_save.currentGraphPath = path

	var code = retrieve_whole_code()
	var dir = path.get_base_dir()
	if !DirAccess.dir_exists_absolute(dir):
		DirAccess.make_dir_recursive_absolute(dir)

	var file = FileAccess.open(path, FileAccess.WRITE)

	if file:
		file.store_string(code)
		file.close()
		print("File saved successfully to: ", path)
	else:
		push_error("Failed to save file to: ", path, " Error: ", FileAccess.get_open_error())
	var packed_scene = PackedScene.new()
	packed_scene.pack(workspace.graph_edit)
	ResourceSaver.save(packed_scene,"./SavedGraph/my_graph.tscn")

func save_file_as(path:String):
	save_graph_manual_serialization(path)

func get_recent_files()->Array[String]:
	return []

func retrieve_whole_code() -> String:
	var whole_code: String = ""
	for i: CodeNodeClass in workspace.code_graph_nodes:
		if i.CodeNodeAssociatedResource and i.CodeNodeAssociatedResource.content:
			whole_code += i.CodeNodeAssociatedResource.content + "\n"
	return whole_code
func save_graph_manual_serialization(path: String):
	var graph_data = GraphDataRes.new()
	graph_data.associated_code_file_path = GlobalManager.current_file_path

	var node_saving_index:int = 0
	# Save nodes
	for node in workspace.graph_edit.get_children():
		if node is CodeNodeClass:
			var node_data = NodeDataRes.new()
			node.name = "Node_" + str(node_saving_index)
			node_data.name = node.name
			node_data.position = node.position_offset
			node_data.size = node.size
			node_data.data = node.data
			graph_data.nodes.append(node_data)
			node_saving_index += 1

	# Save frames
	for frame in workspace.graph_edit.get_children():
		if frame is RectFrameClass:
			var frame_data = FrameDataRes.new()
			frame_data.name = frame.name
			frame_data.frame_title = frame.title
			frame_data.position = frame.position_offset
			frame_data.size = frame.size
			frame_data.color = frame.tint_color
			var n: Array[String] = []
			for i in frame.framed_graph_nodes:
				n.append(i.name)
			frame_data.framed_graph_nodes = n
			graph_data.frames.append(frame_data)
	var res_path:String = path.get_basename() + ".res"
	ResourceSaver.save( graph_data,res_path)
	var new_path: String = path.get_basename() + ".graph"
	DirAccess.remove_absolute(new_path)
	DirAccess.rename_absolute(res_path, new_path)

func load_graph_manual_serialization(path: String):
	if not FileAccess.file_exists(path):
		push_error("no file to load")
		return

	if path.get_extension() != GlobalManager.GraphFileExtension:
		return

	var temp_path = path.get_basename() + ".res"
	if FileAccess.file_exists(temp_path):
		DirAccess.remove_absolute(temp_path)
	DirAccess.copy_absolute(path, temp_path)

	var graph_data = ResourceLoader.load(temp_path) as GraphDataRes
	if not graph_data:
		push_error("Failed to load graph data!")
		DirAccess.remove_absolute(temp_path)
		return

	DirAccess.remove_absolute(temp_path)

	# Clear existing nodes and frames
	for child in workspace.graph_edit.get_children(true):
		if child is CodeNodeClass or child is RectFrameClass:
			child.queue_free()

	var node_map = {}

	# Recreate nodes
	for node_data: NodeDataRes in graph_data.nodes:
		var node: CodeNodeClass = preload("res://CodeNode/CodeNode.tscn").instantiate()
		node.code_edit.scroll_fit_content_height = false
		node.code_edit.scroll_fit_content_width = false
		node.name = node_data.name
		node.position_offset = node_data.position
		node.size = node_data.size
		node.data = node_data.data

		workspace.graph_edit.add_child(node)
		node.apply_data(node_data.data)
		node_map[node.name] = node

	# Recreate frames
	for frame_data: FrameDataRes in graph_data.frames:
		var frame: RectFrameClass = preload("res://RectFrame/RectFrame.tscn").instantiate()
		frame.name = frame_data.name
		frame.title = frame_data.frame_title
		frame.frame_title = frame_data.frame_title
		frame.position_offset = frame_data.position
		frame.size = frame_data.size
		frame.set_frame_color(frame_data.color)
		workspace.graph_edit.add_child(frame)

		var framed_nodes: Array[CodeNodeClass] = []
		for node_name in frame_data.framed_graph_nodes:
			if node_map.has(node_name):
				framed_nodes.append(node_map[node_name])

		frame.set_framed_nodes(framed_nodes)

	emit_signal("graph_loaded",graph_data)
