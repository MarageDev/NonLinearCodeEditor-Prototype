extends GraphNode
class_name CodeNodeClass

# Data Model
var data: CodeNodeRes = CodeNodeRes.new()

# Exported Properties
@export var node_content: String = ""
@export var code_edit: CodeEdit
@export var custom_color: bool = false
@export var custom_node_color: Color = Color.WHITE
@export var node_index: int = 0

# Internal State
var node_title: String = "Blablabla"
var custom_title_bar: GraphNodeTitlebarClass

# Node Setup
func setup_node():
	# Initialize UI from properties
	if node_content and code_edit:
		code_edit.text = node_content
	setup_custom_titlebar(node_title, node_index)
	sync_data_from_properties()

# Data Synchronization
func sync_data_from_properties():
	# Pushes node properties into the data resource
	data.content = node_content
	data.index = node_index
	data.title = node_title
	data.color = custom_node_color

func apply_data(data_res: CodeNodeRes):
	# Loads data into node properties
	node_title = data_res.title
	node_index = data_res.index
	node_content = data_res.content
	custom_node_color = data_res.color

	# Updates UI from properties
	setup_custom_titlebar(node_title, node_index)
	code_edit.text = node_content
	set_graphnode_color(custom_node_color)
	sync_data_from_properties()

# UI Setters (update both UI and properties)
func set_code_content(content: String):
	node_content = content
	code_edit.text = content
	sync_data_from_properties()

func set_node_title(new_title: String):
	node_title = new_title
	if custom_title_bar:
		custom_title_bar.label.text = new_title
	sync_data_from_properties()

func set_node_index(index: int):
	node_index = index
	if custom_title_bar:
		custom_title_bar.label_number.text = str(index)
	sync_data_from_properties()

func set_graphnode_color(color: Color):
	custom_color = true
	custom_node_color = color

	# Update panel style
	var stylebox_panel: StyleBoxFlat = get_theme_stylebox("panel").duplicate()
	stylebox_panel.bg_color = Color.from_hsv(color.h, color.s, 0.09)
	stylebox_panel.border_color = Color.from_hsv(color.h, color.s, 0.14)
	add_theme_stylebox_override("panel", stylebox_panel)

	# Update panel selected style
	var stylebox_panel_selected: StyleBoxFlat = get_theme_stylebox("panel_selected").duplicate()
	stylebox_panel_selected.bg_color = Color.from_hsv(color.h, color.s, 0.09)
	stylebox_panel_selected.border_color = Color.from_hsv(color.h, 0.44, 0.53)
	add_theme_stylebox_override("panel_selected", stylebox_panel_selected)

	# Update titlebar style
	var stylebox_titlebar: StyleBoxFlat = get_theme_stylebox("titlebar").duplicate()
	stylebox_titlebar.bg_color = Color.from_hsv(color.h, color.s, 0.16)
	stylebox_titlebar.border_color = Color.from_hsv(color.h, color.s, 0.14)
	add_theme_stylebox_override("titlebar", stylebox_titlebar)

	# Update titlebar selected style
	var stylebox_titlebar_selected: StyleBoxFlat = get_theme_stylebox("titlebar_selected").duplicate()
	stylebox_titlebar_selected.bg_color = Color.from_hsv(color.h, 0.58, 0.45)
	stylebox_titlebar_selected.border_color = Color.from_hsv(color.h, 0.44, 0.53)
	add_theme_stylebox_override("titlebar_selected", stylebox_titlebar_selected)

	sync_data_from_properties()

# Titlebar Setup
func setup_custom_titlebar(title: String, index: int):
	var default_stylebox = get_theme_stylebox("titlebar")
	if default_stylebox is not StyleBoxFlat:
		return

	var new_stylebox: StyleBoxFlat = default_stylebox.duplicate()
	var titlebar: HBoxContainer = get_titlebar_hbox()

	new_stylebox.content_margin_top = 4
	new_stylebox.content_margin_bottom = 4
	new_stylebox.content_margin_left = 8
	new_stylebox.content_margin_right = 8
	add_theme_stylebox_override("titlebar", new_stylebox)

	# Remove all children (clear default title)
	for child in titlebar.get_children():
		titlebar.remove_child(child)

	# Add custom titlebar node
	var custom_titlebar_node: GraphNodeTitlebarClass = preload("res://CodeNode/GraphNodeTitlebar/GraphNodeTitlebar.tscn").instantiate()
	titlebar.alignment = BoxContainer.ALIGNMENT_CENTER
	titlebar.add_child(custom_titlebar_node)
	titlebar.move_child(custom_titlebar_node, 0)
	custom_title_bar = custom_titlebar_node
	custom_title_bar.double_clicked.connect(_on_titlebar_double_clicked)

	set_node_title(title)
	set_node_index(index)

# Titlebar Rename Logic
func _on_titlebar_double_clicked(pos: Vector2):
	var margin: float = 15.0
	var rename: Control = preload("res://RenameNode/rename_node.tscn").instantiate()
	var parent := get_parent()
	var global_pos = get_global_position()
	rename.position = global_pos + Vector2(0.0, -1.0) * (rename.size.y + margin)
	rename.followed_node = self
	rename.following_offset = Vector2(0.0, -1.0) * (rename.size.y + margin)
	parent.add_child(rename)
	rename.line_edit.grab_focus()
	rename.text_submitted.connect(_node_title_edit)

func _node_title_edit(new_text: String):
	if new_text != "":
		set_node_title(new_text)

# Other
func _on_resize_request(new_size: Vector2) -> void:
	code_edit.scroll_fit_content_height = false
	code_edit.scroll_fit_content_width = false

func _on_code_edit_text_changed() -> void:
	data.content = code_edit.text
