extends Control

@export var titlebar:Titlebar
@export var workspace:Workspace

@onready var logic_test: Control = $LogicTest


func _ready() -> void:
	titlebar.connect("open_settings",open_settings)

var settings_scene
func open_settings():
	if settings_scene : settings_scene.queue_free()
	settings_scene = preload("res://Scenes/Settings/Settings.tscn").instantiate()
	logic_test.add_child(settings_scene)
