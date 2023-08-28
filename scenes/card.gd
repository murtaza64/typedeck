extends Node2D

signal card_done(card, success)

const WIDTH = 1600
const TEXT_INPUT_MAX_WIDTH = 1200

var en10k = FileAccess.open("res://dictionaries/google-10000-english-usa.txt", FileAccess.READ). \
	get_as_text().split("\n")
var en1k = en10k.slice(0, 1000)
var rng = RandomNumberGenerator.new()

func _ready():
	pass

func init():
	var selected_words: PackedStringArray = []
	for i in range(3):
		selected_words.append(en1k[rng.randi_range(0, 999)])
	var text = " ".join(selected_words)
	$text_input.init(text, 1200)
	var text_input_bg = $text_input.get_node("background")
	var text_input_width = text_input_bg.polygon[2].x
	# var center = WIDTH / 2.0
	var center = 0
	$instructions.position.x = center - $instructions.size.x/2
	$instructions.label_settings.font_color = Catppuccin.overlay2
	$text_input.position.x = center - text_input_width/2
	$text_input.completed_typing.connect(_on_typing_completed)

func set_active():
	$text_input.set_active()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_typing_completed():
	$instructions.label_settings.font_color = Catppuccin.green
	card_done.emit(self, true)
