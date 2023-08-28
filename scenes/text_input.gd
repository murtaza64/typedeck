extends Node2D
enum STATE {TYPING, COMPLETED, INACTIVE}

signal completed_typing

var state = STATE.INACTIVE
var letter_scene = load("res://scenes/letter.tscn")
var letters = []
var errors = []
var cursor_pos = 0
var text

const PADDING_LEFT = 30
const PADDING_TOP = 5
const PADDING_RIGHT = 30
const PADDING_BOTTOM = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

const CHAR_WIDTH = 24
const CHAR_HEIGHT = 52
func calc_letters_per_line(max_width):
	return (max_width - PADDING_LEFT - PADDING_RIGHT) / CHAR_WIDTH

func build_layout(text, max_width):
	print(text)
	var words = text.split(" ")
	var max_chars_per_line = calc_letters_per_line(max_width)
	print(max_chars_per_line)
	var lines: PackedStringArray = []
	var current_line = ""
	var max_line_width = 0

	for word in words:
		print(word)
		if len(current_line) + len(word) + 1 > max_chars_per_line:
			lines.append(current_line)
			max_line_width = max(max_line_width, len(current_line))
			current_line = ""
		current_line += word + " "

	if current_line != "":
		lines.append(current_line)
		max_line_width = max(max_line_width, len(current_line))
	
	# -1 accounts for space at end of line
	var width = (max_line_width - 1) * CHAR_WIDTH + PADDING_LEFT + PADDING_RIGHT
	var height = PADDING_TOP + len(lines) * CHAR_HEIGHT + PADDING_BOTTOM
	var center_x = width/2.0
	print(lines)

	for line_i in len(lines):
		var line = lines[line_i]
		var line_width = (len(line) - 1) * CHAR_WIDTH
		var offset_x = center_x - line_width/2.0
		var offset_y = PADDING_TOP + line_i * CHAR_HEIGHT
		for c in line:
			var l = letter_scene.instantiate()
			add_child(l)

			l.position.x = offset_x
			l.position.y = offset_y
			l.set_untyped(c)

			offset_x += CHAR_WIDTH

			letters.append(l)

	# deal with last space
	letters.pop_back()

	$background.polygon = [
		Vector2(0, 0),
		Vector2(0, height),
		Vector2(width, height),
		Vector2(width, 0),
	]
	$background.color = Catppuccin.mantle
	


func init(text_: String, max_width: int):
	text = text_
	build_layout(text, max_width)
	update_cursor_pos()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass	

func set_active():
	state = STATE.TYPING

var lowercase = {
	KEY_A: "a",
	KEY_B: "b",
	KEY_C: "c",
	KEY_D: "d",
	KEY_E: "e",
	KEY_F: "f",
	KEY_G: "g",
	KEY_H: "h",
	KEY_I: "i",
	KEY_J: "j",
	KEY_K: "k",
	KEY_L: "l",
	KEY_M: "m",
	KEY_N: "n",
	KEY_O: "o",
	KEY_P: "p",
	KEY_Q: "q",
	KEY_R: "r",
	KEY_S: "s",
	KEY_T: "t",
	KEY_U: "u",
	KEY_V: "v",
	KEY_W: "w",
	KEY_X: "x",
	KEY_Y: "y",
	KEY_Z: "z",

	KEY_SPACE: " "
}

func is_correct_key_pressed(event):
	if not (event is InputEventKey):
		return false
	if not event.pressed:
		return false
	if event.keycode not in lowercase:
		return false
	if cursor_pos >= len(text):
		return false
	return lowercase[event.keycode] == text[cursor_pos]

func is_incorrect_key_pressed(event):
	if not (event is InputEventKey):
		return false
	if not event.pressed:
		return false
	if event.keycode not in lowercase:
		return false
	if cursor_pos >= len(text):
		return false
	return lowercase[event.keycode] != text[cursor_pos]

func update_cursor_pos():
	if cursor_pos < len(letters):
		var l = letters[cursor_pos]
		$cursor.position.x = l.position.x
		
		$cursor.get_node("Polygon2D").polygon = [
			Vector2(0, 0),
			Vector2(CHAR_WIDTH, 0),
			Vector2(CHAR_WIDTH, 5),
			Vector2(0, 5),
		]
		$cursor.position.y = l.position.y + CHAR_HEIGHT
	else:
		$cursor.position.x += 24

func is_backspace_pressed(event):
	return event is InputEventKey \
		and event.pressed \
		and event.keycode == KEY_BACKSPACE

func _unhandled_input(event):
	match state:
		STATE.TYPING:
			if is_correct_key_pressed(event):
				letters[cursor_pos].set_typed()
				cursor_pos += 1
				if cursor_pos >= len(letters) and not errors:
					state = STATE.COMPLETED
					$cursor.hide()
					completed_typing.emit()
				else:
					update_cursor_pos()
			elif is_backspace_pressed(event):
				if cursor_pos > 0:
					cursor_pos -= 1
					if cursor_pos in errors:
						errors.erase(cursor_pos)
					letters[cursor_pos].set_untyped(text[cursor_pos])
					update_cursor_pos()
			elif is_incorrect_key_pressed(event):
				letters[cursor_pos].set_incorrect(lowercase[event.keycode])
				errors.append(cursor_pos)
				cursor_pos += 1
				update_cursor_pos()
			get_viewport().set_input_as_handled()


