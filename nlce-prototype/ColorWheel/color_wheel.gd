extends Control
class_name ColorWheelClass
@onready var color_picker: ColorPicker = $Panel/MarginContainer/VBoxContainer/ColorPicker
@onready var h_flow_container: HFlowContainer = $Panel/MarginContainer/VBoxContainer/ScrollContainer/HFlowContainer

signal color_changed(new_color)

func _ready() -> void:
	top_level = true

	if ResourceLoader.exists(GlobalManager.SavedColorSwatchesResourcePath):
		var res: SavedColorSamplesResourceClass = load(GlobalManager.SavedColorSwatchesResourcePath)
		for swatch in res.swatches:
			var btn =  preload("res://ColorWheel/ColorSampleButton/ColorSampleButton.tscn").instantiate()
			btn.button_color = swatch.color
			h_flow_container.add_child(btn)

			btn.pressed.connect(
				func(): _on_color_swatches_chosen(btn.button_color)
			)


func _on_color_picker_color_changed(color: Color) -> void:
	emit_signal("color_changed",color)
	queue_free()

func _on_button_pressed() -> void:
	var newColorSwatchesButton := preload("res://ColorWheel/ColorSampleButton/ColorSampleButton.tscn").instantiate()
	newColorSwatchesButton.button_color = color_picker.color
	h_flow_container.add_child(newColorSwatchesButton)

	newColorSwatchesButton.pressed.connect(
		func(): _on_color_swatches_chosen(newColorSwatchesButton.button_color)
	)

	var swatch_resource: SavedColorSamplesResourceClass
	if ResourceLoader.exists(GlobalManager.SavedColorSwatchesResourcePath):
		swatch_resource = load(GlobalManager.SavedColorSwatchesResourcePath)
	else:
		swatch_resource = SavedColorSamplesResourceClass.new()  # Create new if doesn't exist

	var swatch = ColorSampleRessourceClass.new()
	swatch.color = color_picker.color
	swatch.comment = "" # TODO
	swatch_resource.swatches.append(swatch)

	ResourceSaver.save(swatch_resource, GlobalManager.SavedColorSwatchesResourcePath)

func _on_color_swatches_chosen(color: Color) -> void:
	emit_signal("color_changed", color)

	queue_free()


func _on_use_color_button_pressed() -> void:
	emit_signal("color_changed", color_picker.color)

	queue_free()

func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseButton and event.pressed:
		if not get_global_rect().has_point(event.global_position):
			queue_free()
