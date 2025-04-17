extends Button

var button_color:Color = Color.WEB_GREEN

func _ready() -> void:
	var stylebox_panel:StyleBoxFlat = get_theme_stylebox("normal").duplicate()
	stylebox_panel.bg_color = button_color
	add_theme_stylebox_override("normal", stylebox_panel)
	add_theme_stylebox_override("hover", stylebox_panel)
	add_theme_stylebox_override("pressed", stylebox_panel)
	add_theme_stylebox_override("focus", stylebox_panel)
