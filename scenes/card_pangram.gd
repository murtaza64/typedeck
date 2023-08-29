extends "res://scenes/card.gd"

var pangrams = FileAccess.open("res://dictionaries/pangrams.txt", FileAccess.READ) \
	.get_as_text().split("\n")

func init():
	var selected_pangram = Util.random_choice(pangrams)
	selected_pangram = Util.remove_punctuation(selected_pangram, false, false).to_lower()
	set_text_input(selected_pangram)
	set_instructions("Type the pangram")
