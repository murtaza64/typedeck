extends Node2D

var target
var ghost = true

func _ready():
	pass

func set_typed(ch = null):
	# print("set typed")
	$label.label_settings.font_color = Catppuccin.text
	if ch != null:
		$label.text = ch
	else:
		$label.text = target

func set_target(ch):
	target = ch

func set_untyped():
	$glyph_space.hide()
	if ghost:
		$label.label_settings.font_color = Catppuccin.surface2
		$label.text = target
	else:
		$label.text = " "

func set_incorrect(ch):
	if ch == " ":
		$glyph_space.show()
		$glyph_space.modulate = Catppuccin.red
	$label.label_settings.font_color = Catppuccin.red
	$label.text = ch

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
