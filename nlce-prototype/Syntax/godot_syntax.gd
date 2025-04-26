extends CodeEdit

func _ready() -> void:
	var synt:CodeHighlighter = CodeHighlighter.new()
	synt.add_color_region('"','"',Color.DARK_SEA_GREEN)
	synt.add_color_region("#","",Color.DIM_GRAY)
	synt.function_color = Color.DODGER_BLUE
	synt.number_color = Color.PALE_GREEN
	synt.symbol_color = Color.LIGHT_STEEL_BLUE
	synt.member_variable_color = Color.INDIAN_RED
	synt.add_keyword_color("def",Color.YELLOW_GREEN)
	syntax_highlighter = synt
