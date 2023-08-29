extends Node2D

var target
var ghost = true

func _ready():
	pass

func set_typed(char = null):
	# print("set typed")
	$label.label_settings.font_color = Catppuccin.text
	if char != null:
		$label.text = char
	else:
		$label.text = target

func set_target(char):
	target = char

func set_untyped():
	if ghost:
		$label.label_settings.font_color = Catppuccin.surface2
		$label.text = target
	else:
		$label.text = " "

func set_incorrect(char):
	$label.label_settings.font_color = Catppuccin.red
	$label.text = char

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
