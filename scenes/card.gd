extends Node2D

signal card_done(card, success)

const WIDTH = 1600
const TEXT_INPUT_MAX_WIDTH = 1200
const CHAR_WIDTH = 24
const CHAR_HEIGHT = 52

var en10k = FileAccess.open("res://dictionaries/google-10000-english-usa.txt", FileAccess.READ). \
	get_as_text().split("\n")
var en1k = en10k.slice(0, 1000)
var rng = RandomNumberGenerator.new()

func _ready():
	print(get_tree().get_root().get_path())
	print(self.get_path())
	if get_tree().get_root() == self.get_parent():
		init()
		set_active()

func init():
	var selected_words: PackedStringArray = []
	for i in range(3):
		selected_words.append(en1k[rng.randi_range(0, 999)])
	var text = " ".join(selected_words)
	set_text_input(text)
	set_instructions("Type words")
	# set_prompt(text)

func set_text_input(text, ghost = true, variants = null):
	$text_input.init(text, 1200, ghost, variants)
	var text_input_bg = $text_input.get_node("background")
	var text_input_width = text_input_bg.polygon[2].x
	$text_input.position.x = -text_input_width/2
	$text_input.completed_typing.connect(_on_typing_completed)

func set_instructions(text):
	$instructions.text = text
	var width = len(text) * CHAR_WIDTH
	$instructions.position.x = -width/2.0
	$instructions.label_settings.font_color = Catppuccin.overlay2

func set_prompt(text):
	$prompt.text = text
	var width = len(text) * CHAR_WIDTH
	$prompt.position.x = -width/2.0
	$prompt.label_settings.font_color = Catppuccin.text
	$text_input.position.y += CHAR_HEIGHT + 5



func set_active():
	$text_input.set_active()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_typing_completed():
	$instructions.label_settings.font_color = Catppuccin.green
	card_done.emit(self, true)
