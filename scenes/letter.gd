extends Node2D

var label
var target
# Called when the node enters the scene tree for the first time.
func _ready():
	label = get_node("Label")

func set_typed():
	# print("set typed")
	label.label_settings.font_color = Catppuccin.text

func set_untyped(char):
	label.label_settings.font_color = Catppuccin.surface2
	label.text = char

func set_incorrect(char):
	label.label_settings.font_color = Catppuccin.red
	label.text = char

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
