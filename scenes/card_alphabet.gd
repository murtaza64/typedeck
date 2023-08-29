extends "res://scenes/card.gd"

var alphabet = "abcdefghijklmnopqrstuvwxyz"

func init():
	var length = rng.randi_range(6, 10)
	var forward = rng.randi_range(0, 4)
	var start = rng.randi_range(0, 26 - length)
	var text
	if forward:
		text = alphabet.substr(start, length)
	else:
		text = Util.reverse_string(alphabet).substr(start, length)

	set_text_input(text)	
	set_instructions("Type the alphabet snippet")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
