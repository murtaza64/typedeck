extends "res://scenes/card.gd"

static var quotes = FileAccess.open("res://dictionaries/quotes.txt", FileAccess.READ) \
	.get_as_text().split("\n")

func init():
	var chosen_quote = Util.random_choice(quotes).split("\t")
	set_text_input(chosen_quote[1])
	$prompt.text = "— " + chosen_quote[0]	
	var text_input_bg = $text_input.get_node("background")
	var text_input_width = text_input_bg.polygon[2].x
	print($prompt.size.x)
	$prompt.position.x = text_input_width/2 - ((len(chosen_quote[0]) + 2) * CHAR_WIDTH)
	$prompt.position.y = text_input_bg.polygon[2].y
	$prompt.label_settings.font_color = Catppuccin.overlay0
	set_instructions("Type the quote")
