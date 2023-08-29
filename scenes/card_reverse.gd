extends "res://scenes/card.gd"

func init():
	var selected_words: PackedStringArray = []
	for i in range(2):
		selected_words.append(en1k[rng.randi_range(0, 999)])
	var text = " ".join(selected_words)
	set_text_input(Util.reverse_string(text), false)
	set_instructions("Type backwards")
	set_prompt(text)
	$reverse_helper.position.x = $prompt.position.x + $prompt.size.x - 52
	$reverse_helper.position.y = $prompt.position.y - 20
