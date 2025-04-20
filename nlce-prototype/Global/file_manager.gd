extends Node

var workspace:Workspace

var current_file_path:String = ""

func open_selected_file(path:String):
	print(path)
	load_graph(path,"")
func save_file():
	var file_dialog = FileDialog.new()
	file_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	file_dialog.access = FileDialog.ACCESS_FILESYSTEM
	file_dialog.set_use_native_dialog(true)

	add_child(file_dialog)

	file_dialog.file_selected.connect(_on_file_dialog_save_selected)
	file_dialog.popup_centered_ratio()

var saved_file_path:String
func _on_file_dialog_save_selected(path: String):

	saved_file_path = path
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

func save_file_as(file_name:String):
	pass
func get_recent_files()->Array[String]:
	return []


func retrieve_whole_code() -> String:
	var whole_code: String = ""
	for i: GraphCodeNode in workspace.code_graph_nodes:
		if i.CodeNodeAssociatedResource and i.CodeNodeAssociatedResource.content:
			whole_code += i.CodeNodeAssociatedResource.content + "\n"
	return whole_code

func load_graph(scene_path: String, connections_path: String):
	var packed_scene = load(scene_path) as PackedScene
	if packed_scene:
		workspace.graph_edit.queue_free()
		var new_graph = packed_scene.instantiate()
		workspace.add_child(new_graph)
		move_child(new_graph, 0)  # Maintain scene order
