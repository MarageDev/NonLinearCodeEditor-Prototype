extends Control

@onready var workspace: WorkspaceClass = $Workspace
@onready var titlebar: Titlebar = $Titlebar

var settings_scene

func _ready() -> void:
	titlebar.connect("open_settings",open_settings)


func open_settings():
	if settings_scene : settings_scene.queue_free()
	settings_scene = preload("res://Scenes/Settings/Settings.tscn").instantiate()
	workspace.add_child(settings_scene)
