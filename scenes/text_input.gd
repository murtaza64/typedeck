extends Node2D
enum STATE {TYPING, COMPLETED, INACTIVE}

signal completed_typing

var state = STATE.INACTIVE
var letter_scene = load("res://scenes/letter.tscn")
var hint_letters = []
var target_letters = []
var errors = []
var cursor_pos = 0
var target_text

var target_chars_variants = {}

const PADDING_LEFT = 30
const PADDING_TOP = 5
const PADDING_RIGHT = 30
const PADDING_BOTTOM = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

const CHAR_WIDTH = 24
const CHAR_HEIGHT = 52

func init(text: String, max_width: int, ghost = true, variants = null):
	target_text = text
	var lines = split_text_into_lines(target_text, max_width)
	var letter_lines = create_letters(lines, ghost)
	var dims = place_letters(letter_lines, 0)
	draw_background(0, dims[0], 0, dims[1])
	if variants != null:
		print(variants)
		target_chars_variants = variants
	update_cursor_pos()
	return dims

func calc_letters_per_line(max_width):
	return (max_width - PADDING_LEFT - PADDING_RIGHT) / CHAR_WIDTH

func split_text_into_lines(text, max_width):
	var words = text.split(" ")
	var max_chars_per_line = calc_letters_per_line(max_width)
	var lines: PackedStringArray = []
	var current_line = ""

	for word in words:
		print(word)
		if len(current_line) + len(word) + 1 > max_chars_per_line:
			lines.append(current_line)
			current_line = ""
		current_line += word + " "

	if current_line != "":
		# last line should not have a trailing space
		current_line = current_line.rstrip(" ")
		lines.append(current_line)
	else:
		lines[-1] = lines[-1].rstrip(" ")
	print(lines)
	return lines

func max_line_width_ignore_trailing_spaces(letter_lines):
	var max_line_width = 0
	for line in letter_lines:
		if line[-1].target == " ":
			max_line_width = max(max_line_width, len(line) - 1)
		else:
			max_line_width = max(max_line_width, len(line))
	return max_line_width

func place_letters(letter_lines, start_y):
	var max_line_width = max_line_width_ignore_trailing_spaces(letter_lines)
	print(max_line_width)
	var width = max_line_width * CHAR_WIDTH + PADDING_LEFT + PADDING_RIGHT
	var height = PADDING_TOP + len(letter_lines) * CHAR_HEIGHT + PADDING_BOTTOM
	var center_x = width/2.0

	for letter_line_i in len(letter_lines):
		var letter_line = letter_lines[letter_line_i]
		var line_width = len(letter_line) * CHAR_WIDTH
		var offset_x = center_x - line_width/2.0
		var offset_y = start_y + PADDING_TOP + letter_line_i * CHAR_HEIGHT
		for l in letter_line:
			l.position.x = offset_x
			l.position.y = offset_y
			offset_x += CHAR_WIDTH

	return [width, height]

func draw_background(start_x, width, start_y, height):
	$background.polygon = [
		Vector2(start_x, start_y),
		Vector2(start_x, start_y + height),
		Vector2(start_x + width, start_y + height),
		Vector2(start_x + width, start_y),
	]
	$background.color = Catppuccin.mantle


func create_letters(lines, ghost):
	var letters = []
	for line in lines:
		var line_letters = []
		for c in line:
			var l = letter_scene.instantiate()
			add_child(l)
			l.set_target(c)
			l.ghost = ghost
			l.set_untyped()
			line_letters.append(l)
			target_letters.append(l)
		letters.append(line_letters)
	print(letters)
	return letters

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

	KEY_SPACE: " ",
	KEY_MINUS: "-",
}

func is_correct_key_pressed(event):
	if not (event is InputEventKey):
		return false
	if not event.pressed:
		return false
	if event.keycode not in lowercase:
		return false
	if cursor_pos >= len(target_text):
		return false
	return lowercase[event.keycode] == target_text[cursor_pos]

func is_variant_key_pressed(event):
	if not (event is InputEventKey):
		return false
	if not event.pressed:
		return false
	if event.keycode not in lowercase:
		return false
	if cursor_pos >= len(target_text):
		return false
	if cursor_pos not in target_chars_variants:
		return false
	return lowercase[event.keycode] in target_chars_variants[cursor_pos]

func is_incorrect_key_pressed(event):
	if not (event is InputEventKey):
		return false
	if not event.pressed:
		return false
	if event.keycode not in lowercase:
		return false
	if cursor_pos >= len(target_text):
		return false
	return lowercase[event.keycode] != target_text[cursor_pos]

func update_cursor_pos():
	if cursor_pos < len(target_letters):
		var l = target_letters[cursor_pos]
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
				target_letters[cursor_pos].set_typed()
				cursor_pos += 1
				$AudioStreamPlayer.play()
				if cursor_pos >= len(target_letters) and not errors:
					state = STATE.COMPLETED
					$cursor.hide()
					completed_typing.emit()
				else:
					update_cursor_pos()
			elif is_variant_key_pressed(event):
				target_letters[cursor_pos].set_typed(
					lowercase[event.keycode]
				)
				cursor_pos += 1
				$AudioStreamPlayer.play()
				if cursor_pos >= len(target_letters) and not errors:
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
					target_letters[cursor_pos].set_untyped()
					update_cursor_pos()
			elif is_incorrect_key_pressed(event):
				target_letters[cursor_pos].set_incorrect(lowercase[event.keycode])
				errors.append(cursor_pos)
				cursor_pos += 1
				update_cursor_pos()
			get_viewport().set_input_as_handled()


