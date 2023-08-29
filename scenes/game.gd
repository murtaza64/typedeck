extends Node2D

var cards_queue = []
var cards_discarded = []
var rng = RandomNumberGenerator.new()

var card_scene = load("res://scenes/card.tscn")
var card_alphabet_scene = load("res://scenes/card_alphabet.tscn")
var card_reverse_scene = load("res://scenes/card_reverse.tscn")
var card_math_scene = load("res://scenes/card_math.tscn")
var card_url_scene = load("res://scenes/card_url.tscn")
var card_pangram_scene = load("res://scenes/card_pangram.tscn")
var card_quote_scene = load("res://scenes/card_quote.tscn")

var deck = [
	card_scene,
	card_scene,
	card_scene,
]

var card_pool = [
	# card_scene,
	card_alphabet_scene,
	card_reverse_scene,
	card_math_scene,
	card_url_scene,
	card_pangram_scene,
	card_quote_scene,
]

var card_pool_weights = [
	# 1,
	1,
	1,
	1,
	2,
	1,
	1,
]

const CENTER_X = 1920 / 2.0
const CENTER_Y = 1080 / 2.0
# Called when the node enters the scene tree for the first time.
func _ready():
	generate_and_deal_deck()

func animate_card_drop(card, delay = 0.0):
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_interval(delay)
	tween.tween_property(card, "position", Vector2(CENTER_X - 100, CENTER_Y), 0.3)

func generate_and_deal_deck():
	deck.shuffle()
	for i in len(deck):
		var card = deck[i].instantiate()
		cards_queue.append(card)
		add_child(card)
		var angle_offset = rng.randf_range(-2.5, 2.5)
		card.rotation_degrees = angle_offset
		card.position = Vector2(CENTER_X - 100, -600)
		card.init()
		card.card_done.connect(_on_card_completed)
		animate_card_drop(card, 0.1 * i)
	
	select_next_card()

func animate_clear_discard_pile():
	var i = 0
	while cards_discarded:
		var top_card = cards_discarded.pop_back()
		var tween = get_tree().create_tween()
		tween.set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
		tween.tween_interval(i * 0.05)
		tween.tween_property(top_card, "position", Vector2(1800, -600), 0.5)
		tween.tween_callback(top_card.queue_free)
		i += 1

func add_card_to_deck():
	var sc = Util.random_choice_weighted(card_pool, card_pool_weights)
	deck.append(sc)
	var card = sc.instantiate()
	add_child(card)
	card.position = Vector2(CENTER_X - 100, -600)
	card.init()
	card.get_node("card_back/new_banner").show()
	animate_card_drop(card)
	card.set_active()
	card.card_done.connect(_on_new_card_completed)


func select_next_card():
	var card = cards_queue[len(cards_queue) - 1]
	card.set_active()
	# var tween = get_tree().create_tween()
	# tween.tween_interval(0.1)
	# tween.tween_property(card, "rotation_degrees", 0, 0.3)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func animate_card_discard(card):
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

func _on_new_card_completed(card, success):
	animate_card_discard(card)
	cards_discarded.append(card)

	var banner = card.get_node("card_back/new_banner")
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(banner, "modulate:a", 0.0, 0.8)
	tween.tween_callback(banner.hide)
	tween.tween_interval(0.1)
	tween.tween_callback(animate_clear_discard_pile)
	tween.tween_interval(0.5)
	tween.tween_callback(generate_and_deal_deck)

func _on_card_completed(card, success):
	animate_card_discard(card)	
	cards_discarded.append(card)

	cards_queue.pop_back()
	if cards_queue:
		select_next_card()
	else:
		add_card_to_deck()
