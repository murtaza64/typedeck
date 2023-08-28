extends Node2D

var cards_queue = []
var cards_discarded = []
var rng = RandomNumberGenerator.new()

const CENTER_X = 1920 / 2
const CENTER_Y = 1080 / 2
# Called when the node enters the scene tree for the first time.
func _ready():
	generate_and_deal_deck()

func generate_and_deal_deck():
	var card_scene = load("res://scenes/card.tscn")
	for c in range(10):
		var card = card_scene.instantiate()
		cards_queue.append(card)
		add_child(card)
		var angle_offset = rng.randf_range(-2.5, 2.5)
		card.rotation_degrees = angle_offset
		card.position = Vector2(CENTER_X - 100, -600)
		card.init()
		card.card_done.connect(_on_card_completed)
		
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
		tween.tween_interval(c*0.1)
		tween.tween_property(card, "position", Vector2(CENTER_X - 100, CENTER_Y), 0.3)
	
	select_next_card()


func select_next_card():
	var card = cards_queue[len(cards_queue) - 1]
	card.set_active()
	# var tween = get_tree().create_tween()
	# tween.tween_interval(0.1)
	# tween.tween_property(card, "rotation_degrees", 0, 0.3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_card_completed(card, success):
	print("card completed!", success)
	
	move_child(card, -1)

	var angle_offset = rng.randf_range(-10, 10)
	var position_x_offset = rng.randi_range(-10, 10)
	var position_y_offset = rng.randi_range(-10, 10)
	var end_pos = Vector2(
		1800 + position_x_offset,
		800 + position_y_offset
	)
	var tween = get_tree().create_tween()
	tween.set_parallel(true).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(card, "position", end_pos, 0.8)
	tween.tween_property(card, "rotation_degrees", 90 + angle_offset, 0.8)
	tween.tween_property(card, "scale", Vector2(0.2, 0.2), 0.8)
	# tween.set_parallel(false)
	# tween.tween_callback(move_child.bind(card, -1))

	cards_discarded.append(card)

	cards_queue.pop_back()
	if cards_queue:
		select_next_card()
	else:
		generate_and_deal_deck()
