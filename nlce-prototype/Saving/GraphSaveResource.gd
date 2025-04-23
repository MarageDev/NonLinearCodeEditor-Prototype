extends Resource
class_name GraphData
@export var nodes: Array[NodeDataRes]
@export var connections: Array[Dictionary]


func save_graph(path: String,graph_edit_node:GraphEdit):
	var graph_data = GraphData.new()

	# Save nodes
	for node in graph_edit_node.get_children():
		if node is GraphCodeNode:
			var data = NodeDataRes.new()
			data.name = node.name
			data.position = node.position_offset
			data.content = node.CodeNodeAssociatedResource
			graph_data.nodes.append(data)

	# Save connections
	#graph_data.connections = graph_edit_node.get_connection_list()

	# Save as resource
	if ResourceSaver.save(graph_data, path) == OK:
		print("Graph saved successfully")
